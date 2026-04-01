require "test_helper"

class UpvotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @suggestion = suggestions(:two)
  end

  # Happy path tests
  test "should create upvote when authenticated" do
    sign_in_as(@user)
    assert_difference("Upvote.count") do
      post suggestion_upvotes_path(@suggestion), as: :turbo_stream
    end
    assert_response :success
    upvote = Upvote.last
    assert_equal @suggestion.id, upvote.suggestion_id
    assert_equal @user.id, upvote.user_id
  end

  test "should create upvote and return turbo_stream format" do
    sign_in_as(@user)
    post suggestion_upvotes_path(@suggestion), as: :turbo_stream
    assert_response :success
  end

  test "should touch suggestion when creating upvote" do
    sign_in_as(@user)
    original_updated_at = @suggestion.updated_at
    sleep 0.1
    post suggestion_upvotes_path(@suggestion)
    @suggestion.reload
    assert @suggestion.updated_at > original_updated_at
  end

  test "should increment upvotes_count on suggestion" do
    sign_in_as(@user)
    original_count = @suggestion.upvotes_count
    post suggestion_upvotes_path(@suggestion)
    @suggestion.reload
    assert_equal original_count + 1, @suggestion.upvotes_count
  end

  test "should destroy upvote when authenticated" do
    sign_in_as(@user)
    @suggestion_with_upvote = suggestions(:one)
    assert_difference("Upvote.count", -1) do
      delete suggestion_upvote_path(@suggestion_with_upvote, upvotes(:one)), as: :turbo_stream
    end
    assert_response :success
  end

  test "should destroy upvote and return turbo_stream format" do
    sign_in_as(@user)
    @suggestion_with_upvote = suggestions(:one)
    delete suggestion_upvote_path(@suggestion_with_upvote, upvotes(:one)), as: :turbo_stream
    assert_response :success
  end

  test "should decrement upvotes_count when destroying upvote" do
    sign_in_as(@user)
    @suggestion_with_upvote = suggestions(:one)
    original_count = @suggestion_with_upvote.upvotes_count
    delete suggestion_upvote_path(@suggestion_with_upvote, upvotes(:one))
    @suggestion_with_upvote.reload
    assert_equal original_count - 1, @suggestion_with_upvote.upvotes_count
  end

  test "should allow user to toggle upvote" do
    sign_in_as(@user)
    # Create upvote
    post suggestion_upvotes_path(@suggestion), as: :turbo_stream
    assert_response :success
    upvote = Upvote.find_by(suggestion: @suggestion, user: @user)
    assert upvote.present?

    # Destroy upvote
    assert_difference("Upvote.count", -1) do
      delete suggestion_upvote_path(@suggestion, upvote), as: :turbo_stream
    end
    assert_response :success
  end

  # Sad path tests
  test "should redirect to login when creating upvote without authentication" do
    assert_no_difference("Upvote.count") do
      post suggestion_upvotes_path(@suggestion)
    end
    assert_redirected_to new_session_path
  end

  test "should redirect to login when destroying upvote without authentication" do
    assert_no_difference("Upvote.count") do
      delete suggestion_upvote_path(@suggestion, upvotes(:one))
    end
    assert_redirected_to new_session_path
  end

  test "should return 404 when suggestion not found for create" do
    sign_in_as(@user)
    post suggestion_upvotes_path(suggestion_id: 999999), as: :turbo_stream
    assert_response :not_found
  end

  test "should return 404 when suggestion not found for destroy" do
    sign_in_as(@user)
    delete suggestion_upvote_path(suggestion_id: 999999, id: 1), as: :turbo_stream
    assert_response :not_found
  end
end