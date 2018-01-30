class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  attr_accessor :remember_token, :reset_token

  has_many :passive_notifications, class_name: "Notification", foreign_key: "user_get_id"
  has_many :active_notifications, class_name: "Notification", foreign_key: "user_set_id"

  has_many :user_sets, through: :passive_notifications
  has_many :user_gets, through: :active_notifications

  has_many :post
  before_save {self.email = email.downcase}
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

  scope :get_all_users, -> {User.select(:id,:username,:avatar).order(username: :asc)}
  def seen_all
    self.passive_notifications.each do |noti|
      noti.update isSeen: true
    end
  end

  def set_noti other
    user_sets << other
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
    reset_sent_at < (Settings.pass_reset_expired_time).hours.ago
  end
end
