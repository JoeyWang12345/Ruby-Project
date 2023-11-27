class CreateShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_carts do |t|
      # 允许用户在未登录情况下使用购物车，所以user_id可以为空
      t.integer :user_id
      t.string :user_uuid # 未登录下添加购物车，需要追踪其属于哪个用户
      # 当用户使用网站时，在cookie中设置一个uuid，添加购物车时同步这个uuid
      # 当用户注册时，把生成的uuid绑定，登录时，把用户已经有的uuid取出来，更新浏览器保存的uuid
      t.integer :product_id # 商品ID
      t.integer :amount # 商品数量
      t.timestamps
    end

    # 添加索引
    add_index :shopping_carts, [:user_id]
    add_index :shopping_carts, [:user_uuid]
  end
end
