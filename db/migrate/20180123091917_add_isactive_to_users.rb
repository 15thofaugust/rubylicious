class AddIsactiveToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_active, :binary
  end
end
