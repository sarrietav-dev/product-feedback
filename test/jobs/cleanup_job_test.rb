require "test_helper"

class CleanupJobTest < ActiveJob::TestCase
  # Happy path tests
  test "should queue job" do
    assert_enqueued_with(job: CleanupJob) do
      CleanupJob.perform_later
    end
  end

  test "job should use default queue" do
    assert_equal "default", CleanupJob.new.queue_name
  end

  # Note: We skip testing the actual perform method as it runs db:reset
  # which would drop the database and cause test failures
end