class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 用户可以拥有多个地址
  has_many :addresses, -> {where(address_type: Address::AddressType::User).order(id: "desc")}
  # 需要在后面加：optional: true
  belongs_to :default_address, class_name: :Address, optional: true
  has_many :orders
  def username
    self.email.split('@').first # 获得@前面的用户名
  end
end
