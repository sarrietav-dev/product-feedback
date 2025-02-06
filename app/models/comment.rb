class Comment < ApplicationRecord
  belongs_to :suggestion, counter_cache: true
  belongs_to :user

  has_many :replies, dependent: :destroy
end
