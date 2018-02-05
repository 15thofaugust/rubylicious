class Like < ApplicationRecord
  after_create_commit {Notification.create(type_noti: 1, isSeen: false, user_set_id: self.user_id,
    user_get_id: self.post.user_id, post_id: self.post_id)}

  belongs_to :post
  belongs_to :user
  validates :user_id, presence: true
  validates :post_id, presence: true
end
