class RoadmapController < ApplicationController
  def index
    @status_counts = Suggestion.group(:status).count
    @suggestions = Suggestion.includes(:category).all
  end
end
