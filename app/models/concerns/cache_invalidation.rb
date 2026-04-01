module CacheInvalidation
  extend ActiveSupport::Concern

  included do
    after_create :clear_cache_on_create
    after_update :clear_cache_on_update
    after_destroy :clear_cache_on_destroy
  end

  private

  def clear_cache_on_create
    clear_list_caches
  end

  def clear_cache_on_update
    clear_list_caches
    clear_entity_cache
  end

  def clear_cache_on_destroy
    clear_list_caches
    clear_entity_cache
  end

  def clear_list_caches
    case self.class.name
    when "Suggestion"
      # Since we use timestamp-based cache keys, just update the timestamp
      # The touch callbacks on associations will handle updating parent timestamps
      Rails.cache.delete("suggestion_status_counts")
    when "Comment"
      # Touch association will update suggestion's updated_at, invalidating its cache
      Rails.cache.delete("suggestion_status_counts")
    when "Reply"
      # Touch association will update comment's and suggestion's updated_at
      Rails.cache.delete("suggestion_status_counts")
    when "Category"
      Rails.cache.delete("categories/all")
      Rails.cache.delete("suggestion_status_counts")
    end
  end

  def clear_entity_cache
    Rails.cache.delete([self.class.name.downcase, id])
  end
end
