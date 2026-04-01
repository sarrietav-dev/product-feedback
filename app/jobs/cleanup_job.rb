class CleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ProductFeedback::Application.load_tasks

    Rake::Task["db:reset"].invoke
  end
end
