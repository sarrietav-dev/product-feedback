require "test_helper"

class RoadmapControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get roadmap_show_url
    assert_response :success
  end
end
