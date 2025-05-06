class RepliesController < ApplicationController
  def new
    @reply = Reply.new
    @comment = Comment.find(params[:comment_id])
  end

  def create
    @comment = Comment.find(params[:comment_id])
    @reply = Reply.new(reply_params)
    @reply.comment_id = @comment.id
    @reply.user = Current.user
    @reply.replying_to = @comment.user.username

    if @reply.save
      respond_to do |format|
        format.turbo_stream
      end
    else
      redirect_to suggestion_path(@comment.suggestion), status: :unprocessable_entity
    end
  end

  private

  def reply_params
    params.expect(reply: [:content])
  end
end
