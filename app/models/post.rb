class Post < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  # validates :image, presence: true
end
