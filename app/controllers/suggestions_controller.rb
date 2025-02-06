class SuggestionsController < ApplicationController
  def index
    @suggestions = Suggestion.all
    @categories = Category.all
    suggestion_counts = Suggestion.group(:status).count
    @planned_count = suggestion_counts["planned"] || 0
    @in_progress_count = suggestion_counts["in-progress"] || 0
    @live_count = suggestion_counts["live"] || 0
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end

  def new
  end
end
