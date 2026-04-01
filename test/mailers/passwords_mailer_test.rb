require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:one)
  end

  # Happy path tests
  test "reset email is sent to user" do
    email = PasswordsMailer.reset(@user)
    
    assert_emails 1 do
      email.deliver_now
    end
  end

  test "reset email has correct recipient" do
    email = PasswordsMailer.reset(@user)
    
    assert_equal [@user.email_address], email.to
  end

  test "reset email has correct subject" do
    email = PasswordsMailer.reset(@user)
    
    assert_equal "Reset your password", email.subject
  end

  test "reset email has correct from address" do
    email = PasswordsMailer.reset(@user)
    
    assert_equal ["from@example.com"], email.from
  end

  # Edge case tests
  test "reset email handles user with special characters in email" do
    @user.update!(email_address: "user+test@example.com")
    email = PasswordsMailer.reset(@user)
    
    assert_equal ["user+test@example.com"], email.to
  end
end