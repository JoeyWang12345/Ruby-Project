class Address < ApplicationRecord
  validates :user_id, presence: true
  validates :address_type, presence: true
  validates :contact_name, presence: {message: "联系人不可为空"}
  validates :cellphone, presence: {message: "电话号码不可为空"}
  validates :address, presence: {message: "地址不可为空"}

  belongs_to :user
  attr_accessor :set_as_default # 添加属性：是否要设置为默认地址

  after_save :set_as_default_address
  before_destroy :remove_self_as_default_address

  module AddressType
    User = 'user'
    Order = 'order'
  end

  private
  # address记录保存完毕后执行
  def set_as_default_address
    # 如果用户把checkbox点上
    if self.set_as_default.to_i == 1 # 如果传回来的字段等于1，需要设为默认地址
      self.user.default_address = self
      self.user.save!
    else
      # 如果用户当前默认收货地址等于自身，但是用户没有设为默认地址，需要把默认地址从用户记录中删掉
      remove_self_as_default_address
    end
  end

  # 删除之前执行
  def remove_self_as_default_address
    # 一条地址被删除时，如果其正好是用户的默认地址，就需要从用户记录中移除
    if self.user.default_address == self
      self.user.default_address = nil
      self.user.save!
    end
  end
end
