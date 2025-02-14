class Upvote < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :suggestion, counter_cache: true
  belongs_to :user
end
