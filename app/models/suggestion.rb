class Suggestion < ApplicationRecord
  include CacheInvalidation

  belongs_to :user
  belongs_to :category

  has_many :comments, dependent: :destroy
  has_many :upvotes, dependent: :destroy

  validates :title, :description, presence: true

  def cache_key
    "#{model_name.cache_key}/#{id}-#{updated_at.to_fs(:usec)}"
  end

  def cache_key_with_version
    cache_key
  end

  def cache_version
    updated_at.to_fs(:usec)
  end
end
