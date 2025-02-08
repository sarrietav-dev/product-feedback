# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'json'

# Load the JSON data
file_path = Rails.root.join('db', 'data.json')
data = JSON.parse(File.read(file_path))

# Seed the current user
current_user_data = data['currentUser']
current_user = User.find_or_create_by!(
  profile_picture: current_user_data['image'],
  name: current_user_data['name'],
  username: current_user_data['username'],
  email_address: Faker::Internet.email,
  password_digest: BCrypt::Password.create('password')
)

[ "ui", "ux", "enhancement", "bug", "feature" ].each do |category|
  Category.find_or_create_by!(name: category)
end

# Seed product requests and their comments/replies
data['productRequests'].each do |request_data|
  suggestion = Suggestion.create!(
    title: request_data['title'],
    category_id: Category.find_by(name: request_data['category']).id,
    status: request_data['status'],
    description: request_data['description'],
    user_id: current_user.id
  )

  request_data['comments']&.each do |comment_data|
    comment = Comment.create!(
      content: comment_data['content'],
      user_id: User.find_or_create_by!(
        profile_picture: comment_data['user']['image'],
        name: comment_data['user']['name'],
        username: comment_data['user']['username'],
        email_address: Faker::Internet.email,
        password_digest: BCrypt::Password.create('password')
      ).id,
      suggestion_id: suggestion.id
    )

    comment_data['replies']&.each do |reply_data|
      Reply.create!(
        content: reply_data['content'],
        replying_to: reply_data['replyingTo'],
        user_id: User.find_or_create_by!(
          profile_picture: reply_data['user']['image'],
          name: reply_data['user']['name'],
          username: reply_data['user']['username'],
          email_address: Faker::Internet.email,
          password_digest: BCrypt::Password.create('password')
        ).id,
        comment_id: comment.id
      )
    end
  end
end
