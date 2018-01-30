class Post < ApplicationRecord
  belongs_to :user
  has_many :notifications

  validates :user_id, presence: true
  validates :image, presence: true

  scope :posts_by_follower, -> {joins(:user).where "posts.user_id = users.id"}
end
