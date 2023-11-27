class AddUserUuidColumn < ActiveRecord::Migration[7.1]
  def change
    # 给表格添加一个字段
    add_column :users, :uuid, :string

    add_index :users, [:uuid], unique: true

    # 老用户没有uuid，需要移植
    User.find_each do |user|
      # 随机生成uuid字段并保存
      user.uuid = RandomCode.generate_utoken
      user.save
    end
  end
end
