require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @suggestion = suggestions(:one)
  end

  # Happy path tests
  test "should create comment when authenticated with valid params" do
    sign_in_as(@user)
    assert_difference("Comment.count") do
      post suggestion_comments_path(@suggestion), params: {
        comment: {
          content: "This is a new comment"
        }
      }, as: :turbo_stream
    end
    assert_response :success
    comment = Comment.last
    assert_equal @suggestion.id, comment.suggestion_id
    assert_equal @user.id, comment.user_id
  end

  test "should create comment and return turbo_stream format" do
    sign_in_as(@user)
    post suggestion_comments_path(@suggestion), params: {
      comment: { content: "Turbo stream comment" }
    }, as: :turbo_stream
    assert_response :success
  end

  test "should touch suggestion when creating comment" do
    sign_in_as(@user)
    original_updated_at = @suggestion.updated_at
    sleep 0.1
    post suggestion_comments_path(@suggestion), params: {
      comment: { content: "Comment that touches suggestion" }
    }
    @suggestion.reload
    assert @suggestion.updated_at > original_updated_at
  end

  # Sad path tests
  test "should redirect to login when creating comment without authentication" do
    assert_no_difference("Comment.count") do
      post suggestion_comments_path(@suggestion), params: {
        comment: { content: "Unauthorized comment" }
      }
    end
    assert_redirected_to new_session_path
  end

  test "should render show with unprocessable_entity when comment is invalid" do
    sign_in_as(@user)
    assert_no_difference("Comment.count") do
      post suggestion_comments_path(@suggestion), params: {
        comment: { content: "" }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should render show with unprocessable_entity when comment exceeds max length" do
    sign_in_as(@user)
    assert_no_difference("Comment.count") do
      post suggestion_comments_path(@suggestion), params: {
        comment: { content: "a" * 251 }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should return 404 when suggestion not found" do
    sign_in_as(@user)
    post suggestion_comments_path(suggestion_id: 999999), params: {
      comment: { content: "Comment on non-existent suggestion" }
    }, as: :turbo_stream
    assert_response :not_found
  end
end