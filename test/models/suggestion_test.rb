require "test_helper"

class SuggestionTest < ActiveSupport::TestCase
  setup do
    @suggestion = suggestions(:one)
    @user = users(:one)
    @category = categories(:one)
  end

  # Happy path tests
  test "should be valid with all required attributes" do
    suggestion = Suggestion.new(
      title: "Test Title",
      description: "Test Description",
      user: @user,
      category: @category,
      status: "planned"
    )
    assert suggestion.valid?
  end

  test "should belong to user" do
    assert_equal @user, @suggestion.user
  end

  test "should belong to category" do
    assert_equal @category, @suggestion.category
  end

  test "should have many comments" do
    assert_respond_to @suggestion, :comments
  end

  test "should have many upvotes" do
    assert_respond_to @suggestion, :upvotes
  end

  test "should destroy dependent comments" do
    assert_difference("Comment.count", -@suggestion.comments.count) do
      @suggestion.destroy
    end
  end

  test "should destroy dependent upvotes" do
    assert_difference("Upvote.count", -@suggestion.upvotes.count) do
      @suggestion.destroy
    end
  end

  test "cache_key returns correct format" do
    cache_key = @suggestion.cache_key
    assert_match(/suggestions\/\d+-\d{16}/, cache_key)
  end

  test "cache_key_with_version returns same as cache_key" do
    assert_equal @suggestion.cache_key, @suggestion.cache_key_with_version
  end

  test "cache_version returns timestamp in usec format" do
    assert_equal @suggestion.updated_at.to_fs(:usec), @suggestion.cache_version
  end

  # Sad path tests
  test "should be invalid without title" do
    suggestion = Suggestion.new(
      title: nil,
      description: "Test Description",
      user: @user,
      category: @category
    )
    assert_not suggestion.valid?
    assert_includes suggestion.errors[:title], "can't be blank"
  end

  test "should be invalid without description" do
    suggestion = Suggestion.new(
      title: "Test Title",
      description: nil,
      user: @user,
      category: @category
    )
    assert_not suggestion.valid?
    assert_includes suggestion.errors[:description], "can't be blank"
  end

  test "should be invalid without user" do
    suggestion = Suggestion.new(
      title: "Test Title",
      description: "Test Description",
      user: nil,
      category: @category
    )
    assert_not suggestion.valid?
    assert_includes suggestion.errors[:user], "must exist"
  end

  test "should be invalid without category" do
    suggestion = Suggestion.new(
      title: "Test Title",
      description: "Test Description",
      user: @user,
      category: nil
    )
    assert_not suggestion.valid?
    assert_includes suggestion.errors[:category], "must exist"
  end

  test "should be invalid with empty title" do
    suggestion = Suggestion.new(
      title: "",
      description: "Test Description",
      user: @user,
      category: @category
    )
    assert_not suggestion.valid?
    assert_includes suggestion.errors[:title], "can't be blank"
  end

  test "should be invalid with empty description" do
    suggestion = Suggestion.new(
      title: "Test Title",
      description: "",
      user: @user,
      category: @category
    )
    assert_not suggestion.valid?
    assert_includes suggestion.errors[:description], "can't be blank"
  end
end