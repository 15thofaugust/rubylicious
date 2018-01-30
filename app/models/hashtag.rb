class Hashtag < ApplicationRecord
  has_many :post_hashtag

  scope :get_all_hashtags, -> {Hashtag.select(:id,:content)}
end
