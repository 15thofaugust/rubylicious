class CreateCommentUsertags < ActiveRecord::Migration[5.1]
  def change
    create_table :comment_usertags do |t|
      t.integer :comment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
