class AddUserDefaultAddressId < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :default_address_id, :integer
  end
end
