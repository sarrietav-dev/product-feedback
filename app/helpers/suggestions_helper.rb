module SuggestionsHelper
  def cached_status_counts
    Rails.cache.fetch("suggestion_status_counts", expires_in: 10.minutes) do
      Suggestion.group(:status).count.transform_values(&:to_i)
    end
  end

  def cached_category_list
    Rails.cache.fetch("categories/all", expires_in: 1.hour) do
      Category.all.to_a
    end
  end

  def cached_suggestions_count(filter: nil, category: nil)
    cache_key = ["suggestions/count", filter, category&.id].compact.join("/")
    Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      scope = Suggestion.all
      scope = scope.where(category_id: category.id) if category.present?
      scope.count
    end
  end
end
