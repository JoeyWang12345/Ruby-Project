class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      # address_id是指当地址为order类型时，将其关联到这里
      t.integer :user_id, :product_id, :address_id
      t.string :order_no # 订单号
      t.integer :amount # 订单数量(商品数量)
      t.decimal :total_money, precision: 10, scale: 2 # 十位，两位小数点
      t.datetime :payment_at # 支付时间
      t.timestamps
    end

    # 用户id和订单号是索引
    add_index :orders, [:user_id]
    add_index :orders, [:order_no], unique: true
  end
end
