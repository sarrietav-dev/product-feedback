class RoadmapController < ApplicationController
  def index
    @status_counts = Rails.cache.fetch("suggestion_status_counts", expires_in: 10.minutes) do
      Suggestion.group(:status).count
    end

    @current_status = params[:status].presence || "planned"

    # Fetch only the current status suggestions for mobile view
    @filtered_suggestions = Suggestion.includes(:category).where(status: @current_status).order(:created_at)

    # Fetch all suggestions grouped by status for desktop view
    @suggestions_by_status = Suggestion.includes(:category).where(status: ["planned", "in-progress", "live"]).group_by(&:status)
  end
end
