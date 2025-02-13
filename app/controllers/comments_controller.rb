class CommentsController < ApplicationController
  def create
    @suggestion = Suggestion.find(params[:suggestion_id])
    @comment = Comment.new(comment_params)
    @comment.suggestion_id = @suggestion.id
    @comment.user_id = Current.user.id

    if @comment.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      render "suggestions/show", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.expect(comment: [:content])
  end
end
