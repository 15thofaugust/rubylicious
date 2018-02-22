class Follow_Request < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  after_create_commit :create_notification
  before_destroy :destroy_notification

  def destroy_notification
    n1 = Notification.where(type_noti: 5, user_set_id: self.follower_id,
    user_get_id: self.followed_id).first
    unless n1.nil?
      n1.destroy
    end
  end

  def create_notification
    n1 = Notification.create(type_noti: 5, isSeen: false, user_set_id: self.follower_id,
    user_get_id: self.followed_id)
  end

end
