class User < ApplicationRecord
  attr_accessor :remember_token, :reset_token

  enum gender: [:Male, :Female]

  has_many :posts, dependent: :destroy

  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id,
    dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id,
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :like_activities, class_name: Like.name, foreign_key: :user_id,
    dependent: :destroy
  has_many :likes, through: :like_activities, source: :post

  has_many :send_follow_request, class_name: Follow_Request.name,
    foreign_key: :follower_id,
    dependent: :destroy
  has_many :receive_follow_request, class_name: Follow_Request.name,
    foreign_key: :followed_id,
    dependent: :destroy
  has_many :sent_requests, through: :send_follow_request, source: :followed
  has_many :receive_requests, through: :receive_follow_request, source: :follower

  has_many :comments, foreign_key: :user_id, dependent: :destroy
  has_many :passive_notifications, class_name: Notification.name, foreign_key: :user_get_id
  has_many :active_notifications, class_name: Notification.name, foreign_key: :user_set_id
  has_many :user_sets, through: :passive_notifications
  has_many :user_gets, through: :active_notifications
  has_many :post
  mount_uploader :avatar, ImageUploader
  before_save {email.downcase!}
  has_many :comment, dependent: :destroy
  validates :username, presence: true,
    length: {maximum: Settings.username_max_length, minimum: Settings.username_min_length},
    uniqueness: {case_sensitive: false}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.email_max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :fullname, presence: true, length: {maximum: Settings.fullname_max_length}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.pass_min_length},
    allow_nil: true

  scope :get_all_users, -> {select(:id, :username, :fullname,:is_active, :permission, :avatar).order username: :asc}
  scope :suggestion_users, (lambda do |follower_id|
    joins("LEFT JOIN relationships R ON R.followed_id = users.id")
    .where("(users.id NOT IN (SELECT R.followed_id FROM relationships R
      WHERE R.follower_id = :user_id)) AND 1", user_id: follower_id)
    .group("users.id")
    .order("COUNT(R.id) DESC")
    .limit(20)
  end)
  scope :activity_log, (lambda do
    find_by_sql("SELECT * FROM (
      Select comments.id, comments.user_id, comments.post_id, comments.content,
        NULL as followed_id, comments.created_at, 1 as type from comments
      union all
      select likes.id, likes.user_id, likes.post_id, NULL as content,
        NULL as followed_id, likes.created_at, 2 as type from likes
      union all
      select relationships.id, relationships.follower_id as user_id, NULL as post_id,
        NULL as content, relationships.followed_id, relationships.created_at, 3 as type from relationships
    ) results
    where user_id = 3
    order by created_at asc")
  end)

  def seen_all
    self.passive_notifications.each do |noti|
      noti.update isSeen: true
    end
  end

  def set_noti other_user, post
    self.active_notifications.build(user_get_id: other_user.id, post_id: post.id).save
  end

  def get_noti other
    user_gets << other
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def self.from_omniauth auth
    where(email: auth.info.email).first_or_initialize.tap do |user|
      user.fullname = auth.info.name
      user.email = auth.info.email
      user.username = auth.info.email[0,
        auth.info.email.index("@")] + "_" + ("0".."9").to_a.sample(10).join
      user.password = (("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a).sample(8).join
      user.avatar = "avatar/default.png"
      user.save
    end
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.pass_reset_expired_time.hours.ago
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
    Notification.create(type_noti: 4,
      user_set_id: self.id,
      user_get_id: other_user.id,
      isSeen: false)
  end

  def unfollow other_user
    Notification.where(type_noti: 4,
      user_set_id: self.id,
      user_get_id: other_user.id).first.destroy
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  def requesting? other_user
    sent_requests.include? other_user
  end

  def like post
    like_activities.create post_id: post.id
  end

  def unlike post
    likes.destroy post
  end

  def like? post
    likes.include? post
  end
end
