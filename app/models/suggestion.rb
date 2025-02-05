class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :comments
  has_many :upvotes
end
