class AddAncestryToCategory < ActiveRecord::Migration[7.1]
  def change
    # 在表格中添加一列
    add_column :categories, :ancestry, :string

    add_index :categories, [:ancestry]
  end
end
