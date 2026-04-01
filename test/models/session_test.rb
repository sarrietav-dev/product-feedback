require "test_helper"

class SessionTest < ActiveSupport::TestCase
  setup do
    @session = sessions(:one)
    @user = users(:one)
  end

  # Happy path tests
  test "should belong to user" do
    assert_equal @user, @session.user
  end

  test "should be valid with user" do
    new_session = Session.new(user: @user)
    assert new_session.valid?
  end

  test "should be able to create session for user" do
    assert_difference("Session.count") do
      Session.create!(user: @user)
    end
  end

  # Sad path tests
  test "should be invalid without user" do
    session = Session.new(user: nil)
    assert_not session.valid?
    assert_includes session.errors[:user], "must exist"
  end

  test "should store ip_address" do
    session = Session.create!(user: @user, ip_address: "127.0.0.1")
    assert_equal "127.0.0.1", session.ip_address
  end

  test "should store user_agent" do
    session = Session.create!(user: @user, user_agent: "Mozilla/5.0")
    assert_equal "Mozilla/5.0", session.user_agent
  end
end