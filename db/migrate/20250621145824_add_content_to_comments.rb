class AddContentToComments < ActiveRecord::Migration[8.0]
  def change
    add_column :comments, :content, :string
  end
end
