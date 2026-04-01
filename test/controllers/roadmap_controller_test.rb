require "test_helper"

class RoadmapControllerTest < ActionDispatch::IntegrationTest
  setup do
    @planned_suggestion = suggestions(:one)
    @in_progress_suggestion = suggestions(:two)
    @live_suggestion = suggestions(:three)
    @user = users(:one)
  end

  # Happy path tests
  test "should get index when authenticated" do
    sign_in_as(@user)
    get roadmap_index_path
    assert_response :success
  end

  test "should get index with planned status when authenticated" do
    sign_in_as(@user)
    get roadmap_index_path, params: { status: "planned" }
    assert_response :success
  end

  test "should get index with in-progress status when authenticated" do
    sign_in_as(@user)
    get roadmap_index_path, params: { status: "in-progress" }
    assert_response :success
  end

  test "should get index with live status when authenticated" do
    sign_in_as(@user)
    get roadmap_index_path, params: { status: "live" }
    assert_response :success
  end

  # Sad path tests
  test "should redirect to login when accessing roadmap without authentication" do
    get roadmap_index_path
    assert_redirected_to new_session_path
  end

  test "should default to planned status when status param is blank" do
    sign_in_as(@user)
    get roadmap_index_path, params: { status: "" }
    assert_response :success
  end

  test "should handle invalid status gracefully" do
    sign_in_as(@user)
    get roadmap_index_path, params: { status: "invalid-status" }
    assert_response :success
  end

  test "should handle nonexistent status" do
    sign_in_as(@user)
    get roadmap_index_path, params: { status: "nonexistent" }
    assert_response :success
  end
end