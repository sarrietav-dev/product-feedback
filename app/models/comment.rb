class Comment < ApplicationRecord
  belongs_to :suggestion
  belongs_to :user

  has_many :replies, dependent: :destroy
end
