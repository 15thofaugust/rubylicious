class Comment < ApplicationRecord
  after_create_commit :create_notification
  before_destroy :destroy_notification
  belongs_to :user
  belongs_to :post
  validates :content, presence: true
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true

  scope :comments_by_posts, (lambda do
    |post_id, page_num|
    from(Comment.where(post_id: post_id).order(created_at: :desc)
      .limit(Settings.min_comment_load * page_num.to_i), :desc)
    .select("desc.*").order("desc.created_at asc")
  end)
  scope :get_all_post_comments, -> {select(:id, :user_id, :post_id, :content, :created_at)
    .where("post_id = ?","%#{post_id}%").order(created_at: :desc)}

  def destroy_notification
    n1 = Notification.where(type_noti: 2, user_set_id: self.user_id,
    user_get_id: self.post.user_id, post_id: self.post_id).first
    unless n1.nil?
      n1.destroy
    end
  end

  def create_notification
    n1 = Notification.new(type_noti: 2, user_set_id: self.user_id,
      user_get_id: self.post.user_id, post_id: self.post_id)
    if n1.user_set_id != n1.user_get_id
      n1.save
    end
  end

end
