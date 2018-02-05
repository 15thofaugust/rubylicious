class Post < ApplicationRecord
  belongs_to :user
  has_many :notifications
  has_many :post_hashtag
  has_many :be_liked_activites, class_name: Like.name, foreign_key: :post_id,
    dependent: :destroy
  has_many :likes, through: :be_liked_activites, source: :user
  has_many :comments
  validates :user_id, presence: true
  validates :image, presence: true

  mount_uploader :image, ImageUploader

  scope :get_all_posts, (lambda do
    select(:id,:user_id,:image,:caption,:created_at)
      .order created_at: :desc
  end)
  scope :posts_by_follower, (lambda do
    joins(:user).where("posts.user_id = users.id").order created_at: :desc
  end)
  scope :get_post_by_id, -> {select(:id, :user_id, :image, :caption, :created_at)
    .where("id = ?", "%#{post_id}%").order(created_at: :desc)}

  private
  def image_size
    if image.size > Settings.image_max_size.megabytes
      flash.now[:danger] = t "image_size"
    end
  end
end
