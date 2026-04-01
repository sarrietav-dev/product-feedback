require "test_helper"

class UpvoteTest < ActiveSupport::TestCase
  setup do
    @upvote = upvotes(:one)
    @suggestion = suggestions(:one)
    @user = users(:one)
  end

  # Happy path tests
  test "should be valid with all required attributes" do
    upvote = Upvote.new(
      suggestion: @suggestion,
      user: users(:two)
    )
    assert upvote.valid?
  end

  test "should belong to suggestion" do
    assert_equal @suggestion, @upvote.suggestion
  end

  test "should belong to user" do
    assert_equal @user, @upvote.user
  end

  test "should touch suggestion on save" do
    original_updated_at = @suggestion.updated_at
    sleep 0.1
    new_upvote = Upvote.create!(suggestion: @suggestion, user: users(:two))
    @suggestion.reload
    assert @suggestion.updated_at > original_updated_at
  end

  test "should allow multiple users to upvote same suggestion" do
    upvote1 = Upvote.create!(suggestion: @suggestion, user: @user)
    upvote2 = Upvote.create!(suggestion: @suggestion, user: users(:two))
    assert upvote1.persisted?
    assert upvote2.persisted?
  end

  test "should increment upvotes_count on suggestion" do
    original_count = @suggestion.upvotes_count
    Upvote.create!(suggestion: @suggestion, user: users(:two))
    @suggestion.reload
    assert_equal original_count + 1, @suggestion.upvotes_count
  end

  # Sad path tests
  test "should be invalid without suggestion" do
    upvote = Upvote.new(
      suggestion: nil,
      user: @user
    )
    assert_not upvote.valid?
    assert_includes upvote.errors[:suggestion], "must exist"
  end

  test "should be invalid without user" do
    upvote = Upvote.new(
      suggestion: @suggestion,
      user: nil
    )
    assert_not upvote.valid?
    assert_includes upvote.errors[:user], "must exist"
  end
end