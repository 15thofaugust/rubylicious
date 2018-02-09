class AddIsprivateToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :isprivate, :boolean
  end
end
