class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, foreign_key: true
      t.string :image
      t.text :caption

      t.timestamps
    end
    add_index :posts, [:user_id, :created_at]
  end
end
