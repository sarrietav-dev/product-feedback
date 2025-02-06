class Suggestion < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :comments, dependent: :destroy
  has_many :upvotes, dependent: :destroy

  validates :title, :description, presence: true
end
