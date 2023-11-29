class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.integer :user_id # 所属用户
      # 两类地址：地址库(可以编辑)和同订单绑定的地址(不可编辑)
      t.string :address_type # 所以可以分成用户类型地址和订单类型地址
      t.string :contact_name, :cellphone, :address, :zipcode
      t.timestamps
    end
    # 联合索引(左匹配原则)
    add_index :addresses, [:user_id, :address_type]
  end
end
