class Notification < ApplicationRecord
  belongs_to :user_set, class_name: "User"
  belongs_to :user_get, class_name: "User"
  belongs_to :post
end
