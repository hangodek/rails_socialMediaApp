class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  validates :follower_id, uniqueness: { scope: :following_id, message: "You are already following this user" }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:following, "You cannot follow yourself") if follower == following
  end
end
