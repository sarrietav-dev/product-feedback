class RoadmapController < ApplicationController
  def index
    max_updated_at = Suggestion.maximum(:updated_at)
    cache_key = [
      "roadmap/index",
      params[:status] || "planned",
      max_updated_at&.to_fs(:usec)
    ].join("/")

    cached_data = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      status_counts = Suggestion.group(:status).count
      current_status = params[:status].presence || "planned"

      {
        status_counts: status_counts,
        filtered_suggestions: Suggestion.includes(:category).where(status: current_status).order(:created_at).to_a,
        suggestions_by_status: Suggestion.includes(:category).where(status: ["planned", "in-progress", "live"]).group_by(&:status),
        current_status: current_status
      }
    end

    @status_counts = cached_data[:status_counts]
    @current_status = cached_data[:current_status]
    @filtered_suggestions = cached_data[:filtered_suggestions]
    @suggestions_by_status = cached_data[:suggestions_by_status]

    fresh_when etag: cache_key, last_modified: max_updated_at
  end
end
