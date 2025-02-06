class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :suggestion, null: false, foreign_key: {on_delete: :cascade}
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
