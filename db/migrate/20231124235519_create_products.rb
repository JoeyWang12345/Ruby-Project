# 产品模型
class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.integer :category_id # 外键(category表的主键)
      t.string :title
      t.string :status, default: 'off' # 商品状态(上架or下架)，默认为off(实际状态多，布尔类型难以表达)
      t.integer :amount, default: 0 # 商品库存数量，默认0
      t.string :uuid # 商品序列号，显示在前端
      t.decimal :msrp, precision: 10, scale: 2 # 市场建立零售价
      t.decimal :price, precision: 10, scale: 2 # 当前售价
      t.text :description # 商品描述，富文本
      t.timestamps
    end

    # 状态和分类id需要放在索引里(索引支持左匹配,category_id用不上)
    # 所以有必要单独建一个关于category_id的索引
    # 产品编号和名称也可以索引(遇到复杂搜索)
    add_index :products, [:status, :category_id]
    add_index :products, [:category_id]
    add_index :products, [:uuid], unique: true # 限制非空(模型中也可以)
    add_index :products, [:title]
  end
end
