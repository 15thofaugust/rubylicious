class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :type_noti
      t.boolean :isSeen
      t.integer :user_set_id, foreign_key: true
      t.integer :user_get_id, foreign_key: true
      t.integer :post_id, foreign_key: true

      t.timestamps
    end
  end
end
