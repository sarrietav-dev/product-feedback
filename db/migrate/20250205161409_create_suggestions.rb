class CreateSuggestions < ActiveRecord::Migration[8.0]
  def change
    create_table :suggestions do |t|
      t.string :title
      t.string :status
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
