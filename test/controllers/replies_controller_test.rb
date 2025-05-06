require "test_helper"

class RepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)

    sign_in_as users(:john)
  end

  test "create a reply" do
    assert_difference "@comment.replies.count" do
      post comment_replies_url(@comment), params: {
        reply: {
          content: "Hey"
        }
      }
    end
  end

  test "create a reply with invalid params" do
    assert_no_difference "@comment.replies.count" do
      post comment_replies_url(@comment), params: {
        reply: {
          content: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
