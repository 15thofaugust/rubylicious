class CreatePostUsertags < ActiveRecord::Migration[5.1]
  def change
    create_table :post_usertags do |t|
      t.integer :post_id
      t.integer :user_id

      t.timestamps
    end
  end
end
