require "test_helper"

class SuggestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @suggestion = suggestions(:one)
    @category = categories(:one)
  end

  # Happy path tests
  test "should get index when authenticated" do
    sign_in_as(@user)
    get suggestions_path
    assert_response :success
  end

  test "should get index with filter parameter when authenticated" do
    sign_in_as(@user)
    get suggestions_path, params: { filter: "Bug" }
    assert_response :success
  end

  test "should get index with all filter when authenticated" do
    sign_in_as(@user)
    get suggestions_path, params: { filter: "all" }
    assert_response :success
  end

  test "should get index with sort parameter most-upvotes when authenticated" do
    sign_in_as(@user)
    get suggestions_path, params: { sort: "most-upvotes" }
    assert_response :success
  end

  test "should get index with sort parameter least-upvotes when authenticated" do
    sign_in_as(@user)
    get suggestions_path, params: { sort: "least-upvotes" }
    assert_response :success
  end

  test "should get index with sort parameter most-comments when authenticated" do
    sign_in_as(@user)
    get suggestions_path, params: { sort: "most-comments" }
    assert_response :success
  end

  test "should get index with sort parameter least-comments when authenticated" do
    sign_in_as(@user)
    get suggestions_path, params: { sort: "least-comments" }
    assert_response :success
  end

  test "should get index as turbo_stream when authenticated" do
    sign_in_as(@user)
    get suggestions_path, as: :turbo_stream
    assert_response :success
  end

  test "should show suggestion when authenticated" do
    sign_in_as(@user)
    get suggestion_path(@suggestion)
    assert_response :success
  end

  test "should get new when authenticated" do
    sign_in_as(@user)
    get new_suggestion_path
    assert_response :success
  end

  test "should create suggestion when authenticated with valid params" do
    sign_in_as(@user)
    assert_difference("Suggestion.count") do
      post suggestions_path, params: {
        suggestion: {
          title: "New Test Suggestion",
          description: "This is a test description",
          category_id: @category.id
        }
      }
    end
    assert_redirected_to suggestion_path(Suggestion.last)
    assert_equal "planned", Suggestion.last.status
    assert_equal @user.id, Suggestion.last.user_id
  end

  test "should get edit when authenticated as owner" do
    sign_in_as(@user)
    get edit_suggestion_path(@suggestion)
    assert_response :success
  end

  test "should update suggestion when authenticated as owner with valid params" do
    sign_in_as(@user)
    patch suggestion_path(@suggestion), params: {
      suggestion: {
        title: "Updated Title",
        description: "Updated description"
      }
    }
    assert_redirected_to suggestion_path(@suggestion)
    @suggestion.reload
    assert_equal "Updated Title", @suggestion.title
  end

  test "should destroy suggestion when authenticated as owner" do
    sign_in_as(@user)
    assert_difference("Suggestion.count", -1) do
      delete suggestion_path(@suggestion)
    end
    assert_redirected_to suggestions_path
  end

  # Sad path tests
  test "should redirect to login when accessing index without authentication" do
    get suggestions_path
    assert_redirected_to new_session_path
  end

  test "should redirect to login when accessing new without authentication" do
    get new_suggestion_path
    assert_redirected_to new_session_path
  end

  test "should redirect to login when creating suggestion without authentication" do
    assert_no_difference("Suggestion.count") do
      post suggestions_path, params: {
        suggestion: {
          title: "New Suggestion",
          description: "Description",
          category_id: @category.id
        }
      }
    end
    assert_redirected_to new_session_path
  end

  test "should redirect to login when editing suggestion without authentication" do
    get edit_suggestion_path(@suggestion)
    assert_redirected_to new_session_path
  end

  test "should redirect to login when updating suggestion without authentication" do
    patch suggestion_path(@suggestion), params: {
      suggestion: { title: "Updated" }
    }
    assert_redirected_to new_session_path
  end

  test "should redirect to login when destroying suggestion without authentication" do
    assert_no_difference("Suggestion.count") do
      delete suggestion_path(@suggestion)
    end
    assert_redirected_to new_session_path
  end

  test "should render new with unprocessable_entity when suggestion is invalid" do
    sign_in_as(@user)
    assert_no_difference("Suggestion.count") do
      post suggestions_path, params: {
        suggestion: {
          title: "",
          description: "Description",
          category_id: @category.id
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should render edit with unprocessable_entity when update is invalid" do
    sign_in_as(@user)
    patch suggestion_path(@suggestion), params: {
      suggestion: {
        title: "",
        description: "Updated description"
      }
    }
    assert_response :unprocessable_entity
  end

  test "should return 404 when suggestion not found" do
    sign_in_as(@user)
    get suggestion_path(999999)
    assert_response :not_found
  end
end