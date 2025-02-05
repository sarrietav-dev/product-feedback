class User < ApplicationRecord
  has_many :suggestions
  has_many :upvotes
  has_many :replies
  has_many :comments
end
