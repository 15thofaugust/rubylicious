class Comment < ApplicationRecord
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
end
