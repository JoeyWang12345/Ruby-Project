class ShoppingCart < ApplicationRecord
  validates :user_uuid, presence: true
  validates :product_id, presence: true
  validates :amount, presence: true

  belongs_to :product
  # 传递进来一个uuid，查询出该uuid下的所有购物车数据
  scope :by_user_uuid, -> (user_uuid) {where(user_uuid: user_uuid)}

  # 判断应创建 or 更新
  def self.create_or_update!(options = {})
    # 根据uuid和product_id判断
    cond = {
      user_uuid: options[:user_uuid],
      product_id: options[:product_id]
    }
    # 筛选符合cond的条目
    record = where(cond).first
    # 如果有，就更新
    if record
      # 叹号，如果更新失败抛出异常
      # 更新操作把当前数量和新传进来的数量相加
      # TODO 这里cart和record是一样的(结果上看)
      # update方法现在适用
      record.update!(options.merge(amount: record.amount + options[:amount]))
    else
      # 如果没有(record为nil)，直接创建
      record = create!(options)
    end
    # 返回
    record
  end
end
