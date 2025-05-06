require "test_helper"

class RoadmapControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as users(:john)
    get roadmap_index_url
    assert_response :success

    assert_select ".planned-suggestion", 3 * 2 # times 2 for mobile and desktop
  end
end
