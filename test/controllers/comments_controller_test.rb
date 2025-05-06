require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:ui)
    @suggestion = suggestions(:ui)

    sign_in_as users(:john)
  end

  test "should create a comment" do
    assert_difference "@suggestion.comments.count" do
      post suggestion_comments_url(@suggestion), params: {
        comment: {
          content: "Hey"
        }
      }
    end
  end
end
