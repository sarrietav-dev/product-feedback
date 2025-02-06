class AddCommentsCountToSuggestions < ActiveRecord::Migration[8.0]
  def change
    add_column :suggestions, :comments_count, :integer, default: 0, null: false
  end
end
