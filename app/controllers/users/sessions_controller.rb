# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)
    resource&.persisted? ? resource : nil
    if resource
      # 用户登录时，把user模型中的uuid复制到session和cookies中
      update_browser_uuid resource.uuid # 注意是@user
      flash[:notice] = "登录成功"
      redirect_to root_path # 重定向到首页
    else
      flash[:notice] = "邮箱或者密码不正确"
      redirect_to new_user_session_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    flash[:notice] = "退出登录成功"
    yield if block_given?
    redirect_to root_path
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
