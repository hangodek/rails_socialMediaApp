class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post, counter_cache: true
  has_many :likes, as: :likeable, dependent: :destroy

  validates :content, presence: true

  after_save :sync_rich_text_comments_counters

  private

  def sync_rich_text_comments_counters
    post.content.update_columns(
      comments_count: post.comments_count
    ) if post.content.present?
  end
end
