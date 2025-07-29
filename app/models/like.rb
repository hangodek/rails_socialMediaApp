class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true, counter_cache: true

  after_save :sync_rich_text_likes_counters

  private

  def sync_rich_text_likes_counters
    likeable.content.update_columns(
      likes_count: likeable.likes_count
    ) if likeable.content.present?
  end
end
