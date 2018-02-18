class Post < ApplicationRecord
  has_paper_trail

  belongs_to :user
  has_many :notifications
  has_many :photos
  has_many :post_hashtags
  has_many :be_liked_activites, class_name: Like.name, foreign_key: :post_id,
    dependent: :destroy
  has_many :likes, through: :be_liked_activites, source: :user
  has_many :comments
  validates :user_id, presence: true
  accepts_nested_attributes_for :photos

  after_create do
    post = Post.find_by id: self.id
    tags = self.caption.scan /#\w+/
    tags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by content: hashtag.downcase.delete("#")
      PostHashtag.create(post_id: self.id,
        hashtag_id: Hashtag.find_by(content: hashtag.downcase.delete("#")).id)
    end
  end

  before_update do
    post = Post.find_by id: self.id
    post.post_hashtags.delete_all
    tags = self.caption.scan /#\w+/
    tags.uniq.map do |hashtag|
      tag = Hashtag.find_or_create_by content: hashtag.downcase.delete("#")
      PostHashtag.create(post_id: self.id,
        hashtag_id: Hashtag.find_by(content: hashtag.downcase.delete("#")).id)
    end
  end

  scope :get_all_posts, (lambda do
    select(:id,:user_id,:image,:caption,:created_at)
      .order created_at: :desc
  end)

  following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
  scope :posts_by_follower, (lambda do
    |follower_id|
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: follower_id).order(created_at: :desc)
  end)
  scope :get_post_by_id, -> {select(:id, :user_id, :caption, :created_at)
    .where("id = ?", "%#{post_id}%").order(created_at: :desc)}

  private
  def image_size
    if image.size > Settings.image_max_size.megabytes
      flash.now[:danger] = t "image_size"
    end
  end
end
