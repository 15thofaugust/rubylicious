class CreateFollowRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :follow_requests do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.binary :status

      t.timestamps
    end
    add_index :follow_requests, :follower_id
    add_index :follow_requests, :followed_id
    add_index :follow_requests, [:follower_id, :followed_id], unique: true
  end
end
