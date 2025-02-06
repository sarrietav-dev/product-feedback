class CreateUpvotes < ActiveRecord::Migration[8.0]
  def change
    create_table :upvotes do |t|
      t.belongs_to :suggestion, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
