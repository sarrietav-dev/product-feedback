class RoadmapController < ApplicationController
  def index
    @suggestions = Suggestion.all
  end
end
