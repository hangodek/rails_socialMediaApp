class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one_attached :avatar

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes

  has_many :liked_comments, through: :likes, source: :likeable, source_type: "Comment"
  has_many :liked_posts, through: :likes, source: :likeable, source_type: "Post"

  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_follows, source: :following

  has_many :passive_follows, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :username, presence: true, length: { minimum: 6 }, uniqueness: true, if: -> { new_record? || username_changed? }
  validates :email_address, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email address" }, if: -> { new_record? || email_address_changed? }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  validate :email_confirmation_check

  after_commit :create_user_default_avatar

  def self.authenticate_by_omni_auth(auth)
    if User.find_by(email_address: auth.info.email)
      user = User.find_by(email_address: auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
      user.save
      user
    else
      user = User.find_or_initialize_by(provider: auth.provider, uid: auth.uid)
      user.email_address = auth.info.email
      user.email_confirmation = auth.info.email
      user.username = SecureRandom.hex(5)
      user.password = SecureRandom.hex(10)
      user.save
      user
    end
  end

  def create_user_default_avatar
    unless avatar.attached?
      avatar.attach(io: File.open(Rails.root.join("app", "assets", "images", "avatar.png")), filename: "default_avatar.png", content_type: "image/png")
    end
  end

  private

  def email_confirmation_check
    if email_address != email_confirmation
      errors.add(:email_confirmation, "does not match email address")
    end
  end
end
