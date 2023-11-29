class Users::Panel::ProfileController < Users::Panel::BaseController
  # 密码修改逻辑，需要先输入老密码，然后连续输入两次新密码
  def update_password
    # 先判断密码是否有效(验证通过)
    if current_user.valid_password?(params[:old_password])
      # 存储用户连续输入的新密码确认
      current_user.password_confirmation = params[:password_confirmation]
      # 如果修改成功
      if current_user.update_with_password(params[:password])
        flash[:notice] = "修改成功"
        redirect_to users_panel_password_path
      else
        render action: :password
      end
      # 如果旧密码验证失败
    else
      # 手工添加一个错误
      current_user.errors.add :old_password, "原来的密码不正确"
      render action: :password
    end
  end
end
