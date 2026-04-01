require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:one)
    @suggestion = suggestions(:one)
    @user = users(:two)
  end

  # Happy path tests
  test "should be valid with all required attributes" do
    comment = Comment.new(
      content: "This is a valid comment",
      suggestion: @suggestion,
      user: @user
    )
    assert comment.valid?
  end

  test "should belong to suggestion" do
    assert_equal @suggestion, @comment.suggestion
  end

  test "should belong to user" do
    assert_equal @user, @comment.user
  end

  test "should have many replies" do
    assert_respond_to @comment, :replies
  end

  test "should destroy dependent replies" do
    assert_difference("Reply.count", -@comment.replies.count) do
      @comment.destroy
    end
  end

  test "should touch suggestion on save" do
    original_updated_at = @suggestion.updated_at
    sleep 0.1
    @comment.update!(content: "Updated content")
    @suggestion.reload
    assert @suggestion.updated_at > original_updated_at
  end

  test "cache_key returns correct format" do
    cache_key = @comment.cache_key
    assert_match(/comments\/\d+-\d{16}/, cache_key)
  end

  test "cache_key_with_version returns same as cache_key" do
    assert_equal @comment.cache_key, @comment.cache_key_with_version
  end

  # Sad path tests
  test "should be invalid without content" do
    comment = Comment.new(
      content: nil,
      suggestion: @suggestion,
      user: @user
    )
    assert_not comment.valid?
    assert_includes comment.errors[:content], "can't be blank"
  end

  test "should be invalid without suggestion" do
    comment = Comment.new(
      content: "Test content",
      suggestion: nil,
      user: @user
    )
    assert_not comment.valid?
    assert_includes comment.errors[:suggestion], "must exist"
  end

  test "should be invalid without user" do
    comment = Comment.new(
      content: "Test content",
      suggestion: @suggestion,
      user: nil
    )
    assert_not comment.valid?
    assert_includes comment.errors[:user], "must exist"
  end

  test "should be invalid with empty content" do
    comment = Comment.new(
      content: "",
      suggestion: @suggestion,
      user: @user
    )
    assert_not comment.valid?
    assert_includes comment.errors[:content], "can't be blank"
  end

  test "should be invalid with content exceeding 250 characters" do
    comment = Comment.new(
      content: "a" * 251,
      suggestion: @suggestion,
      user: @user
    )
    assert_not comment.valid?
    assert_includes comment.errors[:content], "is too long (maximum is 250 characters)"
  end

  test "should be valid with content at exactly 250 characters" do
    comment = Comment.new(
      content: "a" * 250,
      suggestion: @suggestion,
      user: @user
    )
    assert comment.valid?
  end
end