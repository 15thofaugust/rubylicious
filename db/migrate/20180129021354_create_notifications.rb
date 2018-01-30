class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :type_noti
      t.boolean :isSeen
      t.references :user_set, foreign_key: true
      t.references :user_get, foreign_key: true
      t.references :post, foreign_key: true

      t.timestamps
    end
  end
end
