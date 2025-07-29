# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "faker"

puts "Seeding database....."

# 15.times do
#   Post.find(33) do |post|
#     post.comments.create!(
#       user: User.find(1),
#       content: "Halo"
#     )
#   end
# end
#

15.times do
  email = "#{Faker::Internet.username(specifier: 5..10)}@gmail.com"
  User.create!(
  username: Faker::Internet.username(specifier: 6..10),
  email_address: email,
  email_confirmation: email,  # Use the same email for confirmation
  password: "123123")
end
