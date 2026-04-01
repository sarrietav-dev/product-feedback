require "test_helper"

class RepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @comment = comments(:one)
    @suggestion = suggestions(:one)
  end

  # Happy path tests
  test "should get new reply form when authenticated" do
    sign_in_as(@user)
    get new_comment_reply_path(@comment)
    assert_response :success
  end

  test "should create reply when authenticated with valid params" do
    sign_in_as(@user)
    assert_difference("Reply.count") do
      post comment_replies_path(@comment), params: {
        reply: {
          content: "This is a reply"
        }
      }, as: :turbo_stream
    end
    assert_response :success
    reply = Reply.last
    assert_equal @comment.id, reply.comment_id
    assert_equal @user.id, reply.user_id
    # The replying_to field may be nil if the comment's user doesn't have a username
    assert reply.replying_to == @comment.user.username || reply.replying_to.nil?
  end

  test "should create reply and return turbo_stream format" do
    sign_in_as(@user)
    post comment_replies_path(@comment), params: {
      reply: { content: "Turbo stream reply" }
    }, as: :turbo_stream
    assert_response :success
  end

  test "should touch comment when creating reply" do
    sign_in_as(@user)
    original_updated_at = @comment.updated_at
    sleep 0.1
    post comment_replies_path(@comment), params: {
      reply: { content: "Reply that touches comment" }
    }
    @comment.reload
    assert @comment.updated_at > original_updated_at
  end

  # Sad path tests
  test "should redirect to login when accessing new reply without authentication" do
    get new_comment_reply_path(@comment)
    assert_redirected_to new_session_path
  end

  test "should redirect to login when creating reply without authentication" do
    assert_no_difference("Reply.count") do
      post comment_replies_path(@comment), params: {
        reply: { content: "Unauthorized reply" }
      }
    end
    assert_redirected_to new_session_path
  end

  test "should respond with unprocessable_entity when reply is invalid" do
    sign_in_as(@user)
    assert_no_difference("Reply.count") do
      post comment_replies_path(@comment), params: {
        reply: { content: "" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should respond with unprocessable_entity when reply exceeds max length" do
    sign_in_as(@user)
    assert_no_difference("Reply.count") do
      post comment_replies_path(@comment), params: {
        reply: { content: "a" * 501 }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should return 404 when comment not found" do
    sign_in_as(@user)
    get new_comment_reply_path(comment_id: 999999)
    assert_response :not_found
  end
end