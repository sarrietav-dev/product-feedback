ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module SignInHelper
  def sign_in_as(user)
    post session_url, params: { email_address: user.email_address, password: "password" }
  end
end

module ActiveSupport
  include SignInHelper
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    Rails.application.config.assets.paths << Rails.root.join("test", "fixtures", "files")
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end
