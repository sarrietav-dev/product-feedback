class SuggestionsController < ApplicationController
  def index
    @suggestions = Suggestion.all
    @categories = Category.all
    @planned_count = Suggestion.where(status: "planned").count
    @in_progress_count = Suggestion.where(status: "in-progress").count
    @live_count = Suggestion.where(status: "live").count
  end

  def show
    @suggestion = Suggestion.find(params[:id])
  end
end
