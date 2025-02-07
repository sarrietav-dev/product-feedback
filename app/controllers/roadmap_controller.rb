class RoadmapController < ApplicationController
  def show
    @suggestions = Suggestion.where(status: params[:id])
  end
end
