class CreateReplies < ActiveRecord::Migration[8.0]
  def change
    create_table :replies do |t|
      t.string :content
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true
      t.string :replying_to

      t.timestamps
    end
  end
end
