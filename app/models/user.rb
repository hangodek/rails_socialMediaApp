class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :username, presence: true, length: { minimum: 6 }, uniqueness: true
  validates :email_address, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email address" }
  validates :password, presence: true, length: { minimum: 6 }

  validate :email_confirmation_check

  def email_confirmation_check
    if email_address != email_confirmation
      errors.add(:email_confirmation, "does not match email address")
    end
  end
end
