class AddCategoryToSuggestion < ActiveRecord::Migration[8.0]
  def change
    add_reference :suggestions, :category, null: false, foreign_key: true
  end
end
