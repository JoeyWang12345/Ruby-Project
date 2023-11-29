# 分类模型
class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :title # 分类名称
      t.integer :weight, default: 0 # 权重，针对该字段大小做展示上的排序
      t.integer :products_counter, default: 0 # 该分类下产品数
      t.timestamps
    end
    # 建立对这个表的索引(将来可能针对title建立索引)
    add_index :categories, [:title]
  end
end
