class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true

  scope :comments_by_posts, (lambda do
    |post_id, page_num|
    from(Comment.where(post_id: post_id).order(created_at: :desc)
      .limit(Settings.min_comment_load * page_num.to_i), :desc)
    .select("desc.*").order("desc.created_at asc")
  end)
end
