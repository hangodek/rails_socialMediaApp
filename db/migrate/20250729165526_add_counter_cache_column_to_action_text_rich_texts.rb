class AddCounterCacheColumnToActionTextRichTexts < ActiveRecord::Migration[8.0]
  def change
    add_column :action_text_rich_texts, :likes_count, :integer, default: 0
    add_column :action_text_rich_texts, :comments_count, :integer, default: 0
  end
end
