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
      Rails.cache.delete_matched("suggestions/index/*")
      Rails.cache.delete_matched("roadmap/index/*")
      Rails.cache.delete("suggestion_status_counts")
    when "Comment"
      Rails.cache.delete_matched("suggestions/index/*")
      Rails.cache.delete_matched("suggestions/show/*")
      Rails.cache.delete_matched("suggestions/comments/*")
    when "Reply"
      Rails.cache.delete_matched("suggestions/show/*")
      Rails.cache.delete_matched("suggestions/comments/*")
      Rails.cache.delete_matched("comment/replies/*")
    when "Category"
      Rails.cache.delete_matched("categories/*")
      Rails.cache.delete_matched("suggestions/index/*")
    end
  end

  def clear_entity_cache
    Rails.cache.delete([self.class.name.downcase, id])
  end
end
