class Comment < ApplicationRecord
  include CacheInvalidation

  belongs_to :suggestion, counter_cache: true, touch: true
  belongs_to :user

  has_many :replies, dependent: :destroy

  validates :content, presence: true, length: { maximum: 250 }

  def cache_key
    "#{model_name.cache_key}/#{id}-#{updated_at.to_fs(:usec)}"
  end

  def cache_key_with_version
    cache_key
  end
end
