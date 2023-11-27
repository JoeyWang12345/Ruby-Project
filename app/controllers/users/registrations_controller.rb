# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new # new页面，注册的表单页面
    @user = User.new
  end

  # POST /resource
  def create # 表单提交的页面
    # 创建一个新的数据记录，传进来的是前端的表单，主体是一个user，里面有三个参数
    @user = User.new(params.require(:user).
      permit(:email, :password, :password_confirmation))
    # 用户注册时，把uuid绑定(取得session中的uuid)
    @user.uuid = session[:user_uuid]

    if @user.save # 验证通过，数据保存成功
      flash[:notice] = "注册成功，请登录"
      redirect_to new_user_session_path # 重定向到登录页面
    else # 保存失败，即用户验证未通过
      render action: :new # 返回new表单页面
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
