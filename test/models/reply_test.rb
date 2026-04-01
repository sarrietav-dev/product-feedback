require "test_helper"

class ReplyTest < ActiveSupport::TestCase
  setup do
    @reply = replies(:one)
    @comment = comments(:one)
    @user = users(:one)
  end

  # Happy path tests
  test "should be valid with all required attributes" do
    reply = Reply.new(
      content: "This is a valid reply",
      comment: @comment,
      user: @user,
      replying_to: "username"
    )
    assert reply.valid?
  end

  test "should belong to comment" do
    assert_equal @comment, @reply.comment
  end

  test "should belong to user" do
    assert_equal @user, @reply.user
  end

  test "should touch comment on save" do
    original_updated_at = @comment.updated_at
    sleep 0.1
    @reply.update!(content: "Updated reply content")
    @comment.reload
    assert @comment.updated_at > original_updated_at
  end

  test "cache_key returns correct format" do
    cache_key = @reply.cache_key
    assert_match(/replies\/\d+-\d{16}/, cache_key)
  end

  test "cache_key_with_version returns same as cache_key" do
    assert_equal @reply.cache_key, @reply.cache_key_with_version
  end

  # Sad path tests
  test "should be invalid without content" do
    reply = Reply.new(
      content: nil,
      comment: @comment,
      user: @user
    )
    assert_not reply.valid?
    assert_includes reply.errors[:content], "can't be blank"
  end

  test "should be invalid without comment" do
    reply = Reply.new(
      content: "Test content",
      comment: nil,
      user: @user
    )
    assert_not reply.valid?
    assert_includes reply.errors[:comment], "must exist"
  end

  test "should be invalid without user" do
    reply = Reply.new(
      content: "Test content",
      comment: @comment,
      user: nil
    )
    assert_not reply.valid?
    assert_includes reply.errors[:user], "must exist"
  end

  test "should be invalid with empty content" do
    reply = Reply.new(
      content: "",
      comment: @comment,
      user: @user
    )
    assert_not reply.valid?
    assert_includes reply.errors[:content], "is too short (minimum is 1 character)"
  end

  test "should be invalid with content exceeding 500 characters" do
    reply = Reply.new(
      content: "a" * 501,
      comment: @comment,
      user: @user
    )
    assert_not reply.valid?
    assert_includes reply.errors[:content], "is too long (maximum is 500 characters)"
  end

  test "should be valid with content at exactly 500 characters" do
    reply = Reply.new(
      content: "a" * 500,
      comment: @comment,
      user: @user
    )
    assert reply.valid?
  end

  test "should be valid with content at exactly 1 character" do
    reply = Reply.new(
      content: "a",
      comment: @comment,
      user: @user
    )
    assert reply.valid?
  end
end