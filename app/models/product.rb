class Product < ApplicationRecord
  validates :category_id, presence: {message: "商品分类不可为空"}
  validates :title, presence: {message: "商品名称不可为空"}
  validates :status, inclusion: {in: %w[on off], message: "商品状态只能为on或off"}
  validates :amount, presence: {message: "商品库存不可为空"}
  validates :amount, numericality: {only_integer: true, message: "商品库存必须为整数"},
            if: proc {|product| !product.msrp.blank?} # 只有不为空时才校验数字
  validates :msrp, presence: {message: "msrp不可为空"}
  validates :price, presence: {message: "price不可为空"}
  validates :msrp, numericality: {message: "msrp必须为数字"},
            if: proc {|product| !product.msrp.blank?} # 只有不为空时才校验数字
  validates :price, numericality: {message: "商品价格必须为数字"},
            if: proc {|product| !product.msrp.blank?} # 只有不为空时才校验数字
  validates :description, presence: {message: "商品描述不可为空"}

  belongs_to :category # 属于哪个分类
  # 商品在创建之前，生成uuid
  before_create :set_default_attrs

  # 这里要加上商品图片的声明，还没实现 TODO

  # 利用scope定义上架商品,默认的查询
  scope :onshelf, -> {where(status: Status::ON)}

  # 当前商品的状态常量
  module Status
    ON = 'on'
    OFF = 'off'
  end

  private
  # 为商品生成唯一的uuid(随机字符串)
  def set_default_attrs
    # 生成随机的uuid(实在不行就手工随机数)
    # puts "testxxx"
    self.uuid = RandomCode.generate_product_uuid
  end
end
