class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  attr_accessor :remember_token, :reset_token

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
