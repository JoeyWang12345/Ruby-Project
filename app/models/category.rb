class Category < ApplicationRecord
  validates :title, presence: {message: "名称不可以为空"} # 验证
  validates :title, uniqueness: {message: "名字不可以重复"}
  has_many :products, dependent: :destroy # 一对多的关系，且删除分类会同步删除全部产品
  # 删除一级分类时，其子分类全都删掉
  has_ancestry orphan_strategy: :destroy

  before_validation :correct_ancestry

  # 取得当前网站一二级分类的树形结构
  def self.grouped_data
    # 获取根分类集合并排序，使用inject([])初始化一个空的结果数组result，后遍历每个根分类
    self.roots.order("weight desc").inject([]) do |result, parent|
      # 空的临时数组，存放每个根分类及其子分类
      row = []
      row << parent # 把一级分类和所属的二级分类放进去
      # 扫描整个系统的一二级分类，可以放在rails的缓存中，可以提高效率
      row << parent.children.order("weight desc")
      # 将包含当前根分类及其子分类的 row 添加到结果数组 result 中。
      result << row # 每一行是当前根分类和其所有子分类
    end
  end

  private
  def correct_ancestry # 如果没有ancestry传入的是空串，就把他设为nil
    self.ancestry = nil if self.ancestry.blank?
  end
end
