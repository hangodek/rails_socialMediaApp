class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  after_save :sync_rich_text_counters

  private

  def sync_rich_text_counters
    content.update_columns(
      likes_count: likes_count,
      comments_count: comments_count
    ) if content.present?
  end
end
