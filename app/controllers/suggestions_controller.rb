class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: %i[ edit update show destroy ]

  def index
    sort_options = {
      "most-upvotes"   => "COUNT(upvotes.id) DESC",
      "least-upvotes"  => "COUNT(upvotes.id) ASC",
      "most-comments"  => "COUNT(comments.id) DESC",
      "least-comments" => "COUNT(comments.id) ASC"
    }

    sort_order = sort_options[params[:sort]]

    @suggestions = Suggestion
      .left_joins(:upvotes, :comments)
      .group(:id)
      .order(sort_order || "COUNT(upvotes.id) DESC")

    suggestion_counts = Suggestion.group(:status).count
    @planned_count = suggestion_counts["planned"] || 0
    @in_progress_count = suggestion_counts["in-progress"] || 0
    @live_count = suggestion_counts["live"] || 0
  end

  def show
  end

  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    if @suggestion.save
      redirect_to @suggestion
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @suggestion.update(suggestion_params)
      redirect_to @suggestion
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @suggestion.destroy
    redirect_to suggestions_path
  end

  private
    def set_suggestion
      @suggestion = Suggestion.find(params[:id])
    end

    def suggestion_params
      params.expect(suggestion: [ :title, :description, :category_id ])
    end
end
