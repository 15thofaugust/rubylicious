class AddIsactiveToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_active, :integer, default: 1
  end
end
