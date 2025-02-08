class CommentsController < ApplicationController
  def create
    @suggestion = Suggestion.find(params[:suggestion_id])
    @comment = Comment.new(comment_params)
    @comment.suggestion_id = @suggestion.id
    @comment.user_id = Current.user.id

    if @comment.save
      redirect_to suggestion_path(params[:suggestion_id])
    else
      render "suggestions/show", status: :unprocessable_entity
    end
  end

  private
    def comment_params
      params.expect(comment: [ :content ])
    end
end
