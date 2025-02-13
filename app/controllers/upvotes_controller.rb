class UpvotesController < ApplicationController
  def create
    @suggestion = Suggestion.find(params[:suggestion_id])
    @upvote = Upvote.new
    @upvote.user_id = Current.user.id
    @upvote.suggestion_id = @suggestion.id

    if @upvote.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render suggestions_path, status: :unprocessable_entity
    end
  end

  def destroy
    @suggestion = Suggestion.find(params[:suggestion_id])
    @upvote = @suggestion.upvotes.find_by(user: Current.user)

    if @upvote
      @upvote.destroy!
    else
      render suggestions_path, status: :not_found
    end

    respond_to do |format|
      format.turbo_stream
    end
  end
end
