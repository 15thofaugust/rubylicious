class Like < ApplicationRecord
  after_create_commit :create_notification
  before_destroy :destroy_notification

  belongs_to :post
  belongs_to :user
  validates :user_id, presence: true
  validates :post_id, presence: true

  def destroy_notification
    n1 = Notification.where(type_noti: 1, user_set_id: self.user_id,
    user_get_id: self.post.user_id, post_id: self.post_id).first
    unless n1.nil?
      n1.destroy
    end
  end

  def create_notification
    n1 = Notification.new(type_noti: 1, isSeen: false, user_set_id: self.user_id,
    user_get_id: self.post.user_id, post_id: self.post_id)
    if n1.user_set_id != n1.user_get_id
      n1.save
    end
  end
end
