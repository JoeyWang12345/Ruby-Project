class Admin::BaseController < ActionController::Base
  # 把这句话注释以后，不能形成页面，说明是有用的
  layout 'admin/layouts/admin' # 设置模板路径

  # 认证是否为管理员
  before_action :auth_admin

  private
  def auth_admin
    # 因为is_admin是boolean类型的，故可以直接用问号
    unless user_signed_in? and current_user.is_admin?
      flash[:notice] = "请以管理员身份登录"
      redirect_to new_user_session_path
    end
  end
end