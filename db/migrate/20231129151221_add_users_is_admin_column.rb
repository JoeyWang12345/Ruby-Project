class AddUsersIsAdminColumn < ActiveRecord::Migration[7.1]
  def change
    # 用户默认不是管理员
    add_column :users, :is_admin, :boolean, default: false
  end
end
