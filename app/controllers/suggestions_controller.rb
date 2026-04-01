class SuggestionsController < ApplicationController
  before_action :set_suggestion, only: %i[edit update show destroy]

  def index
    sort_options = {
      "most-upvotes" => "COUNT(upvotes.id) DESC",
      "least-upvotes" => "COUNT(upvotes.id) ASC",
      "most-comments" => "COUNT(comments.id) DESC",
      "least-comments" => "COUNT(comments.id) ASC"
    }

    sort_order = sort_options.fetch(params[:sort], "COUNT(upvotes.id) DESC")

    @suggestions = if params[:filter].present? && params[:filter] != "all"
      category = Category.find_by(name: params[:filter])
      Suggestion.where(category_id: category&.id)
    else
      Suggestion.all
    end

    @suggestions = @suggestions
      .left_joins(:upvotes, :comments)
      .group(:id)
      .order(sort_order)

    status_counts = Suggestion.group(:status).count.transform_values(&:to_i)

    @planned_count = status_counts.fetch("planned", 0)
    @in_progress_count = status_counts.fetch("in-progress", 0)
    @live_count = status_counts.fetch("live", 0)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @suggestion = Suggestion.includes(comments: [:user, :replies]).find(params[:id])
    @comment = Comment.new
  end

  def new
    @suggestion = Suggestion.new
    @category_options = Category.all.map { |c| [c.capitalized_name, c.id] }
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion.user_id = Current.user.id
    @suggestion.status = "planned"
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
    params.expect(suggestion: [:title, :description, :category_id])
  end
end
