class Post < ApplicationRecord
  belongs_to :user
  has_many :notifications
  has_many :post_hashtag
  validates :user_id, presence: true
  validates :image, presence: true

  mount_uploader :image, ImageUploader

  scope :get_all_posts, -> {Post.select(:id,:user_id,:image,:caption,:created_at)
    .order(created_at: :desc)}

  scope :posts_by_follower, -> {joins(:user).where("posts.user_id = users.id")
    .order(created_at: :desc)}
  private

  def image_size
    if image.size > 5.megabytes
      flash.now[:danger] = t "image_size"
    end
  end
end
