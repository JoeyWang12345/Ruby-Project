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

  # 手动添加验证方法
  validates :password, presence: {message: "密码不可为空"}
  validates :password_confirmation, presence: {message: "确认密码不可为空"}
  validates_confirmation_of :password, {message: "两次输入密码不一致"}
  validates_length_of :password, message: "密码最短为6位", minimum: 6

  # 验证用户注册时的邮箱
  validate :validate_email, on: :create

  # 邮箱格式自定义
  EMAIL_REGEX = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/


  def username
    self.email.split('@').first # 获得@前面的用户名
  end

  private
  def validate_email
    if self.email.blank?
      self.errors.add :email, "用户邮箱不可为空"
      return false
    else
      unless self.email =~ EMAIL_REGEX
        self.errors.add :email, "用户邮箱格式不正确"
        return false
      end
    end
    true
  end
end
