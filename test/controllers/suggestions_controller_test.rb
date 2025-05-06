require "test_helper"

class SuggestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:ui)
    @suggestion = suggestions(:ui)
    sign_in_as users(:john)
  end

  test "should get index" do
    get suggestions_url
    assert_response :success
    assert_dom "p#suggestion-count", "7 Suggestions"
  end

  test "should get new" do
    get new_suggestion_url
    assert_response :success
  end

  test "should create suggestion" do
    assert_difference("Suggestion.count") do
      post suggestions_url, params: {
        suggestion: {
          title: "New Suggestion",
          description: "Something useful",
          category_id: @category.id
        }
      }
    end
    assert_redirected_to suggestion_path(Suggestion.last)
  end

  test "should show suggestion" do
    get suggestion_url(@suggestion)
    assert_response :success
    assert_select "h1", /#{@suggestion.title}/i
  end
end
