class Reply < ApplicationRecord
  include CacheInvalidation

  belongs_to :user
  belongs_to :comment, touch: true

  validates :content, presence: true, length: { maximum: 500, minimum: 1 }

  def cache_key
    "#{model_name.cache_key}/#{id}-#{updated_at.to_fs(:usec)}"
  end

  def cache_key_with_version
    cache_key
  end
end
