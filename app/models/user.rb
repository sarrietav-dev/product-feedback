class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :suggestions
  has_many :upvotes
  has_many :replies
  has_many :comments

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
