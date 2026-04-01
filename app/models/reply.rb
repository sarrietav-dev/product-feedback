class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :content, presence: true, length: { maximum: 500, minimum: 1 }
end
