class Upvote < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :suggestion, counter_cache: true
  belongs_to :user

  after_create_commit { broadcast_upvote_update }
  after_destroy_commit { broadcast_upvote_update }

  private

  def broadcast_upvote_update
    Turbo::StreamsChannel.broadcast_replace_to(
      dom_id(suggestion),
      target: dom_id(suggestion, "mobile"),
      partial: "upvotes/upvote",
      locals: {suggestion: suggestion, device: :mobile}
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      dom_id(suggestion),
      target: dom_id(suggestion, "desktop"),
      partial: "upvotes/upvote",
      locals: {suggestion: suggestion, device: :desktop}
    )
  end
end
