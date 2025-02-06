class Upvote < ApplicationRecord
  belongs_to :suggestion, counter_cache: true
  belongs_to :user
end
