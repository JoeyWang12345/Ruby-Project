class Order < ApplicationRecord
  validates :user_id, presence: true
  validates :product_id, presence: true
  validates :address_id, presence: true
  validates :total_money, presence: true
  validates :amount, presence: true
  validates :order_no, uniqueness: true

  belongs_to :user
  belongs_to :product
  belongs_to :address

  # 创建前生成订单号
  before_create :gen_order_no

  # 类方法，创建新的订单，叹号表示危险
  def self.create_order!(current_user, address, *shopping_carts)
    shopping_carts.flatten! # 将数组平摊为一维的(可能传入多维)
    # 需要将地址和具体订单绑定(以防用户更改地址)，并去掉一些不需要的属性
    # attributes返回哈希类型，使用except排除一些属性
    address_attrs = address.attributes.except!("id", "created_at", "updated_at")

    # 放在一个事务中，保证数据库一致性
    self.transaction do
      # 在用户的地址集合中创建一个新地址，根据参数创建
      order_address = current_user.addresses.create!(address_attrs.merge(
        "address_type" => Address::AddressType::Order
      ))
      # 遍历购物车，生成订单
      shopping_carts.each do |shopping_cart|
        # 创建订单
        current_user.orders.create!(
          product: shopping_cart.product,
          address: order_address,
          amount: shopping_cart.amount,
          # 计算总价钱，数量乘以单价
          total_money: shopping_cart.amount * shopping_cart.product.price
        )
      end

      # 删除购物车(因为已经放到了订单里)
      shopping_carts.map(&:destroy!)
    end
  end

  private
  def gen_order_no # 为order生成uuid
    self.order_no = RandomCode.generate_order_uuid
  end
end
