# frozen_string_literal: true

require "ruby_mal_client"

RubyMalClient.configure do |config|
  config.client_id = "ab75fe72617c2d1ab411e46bb31c144f"
  config.client_secret = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"
end

user = RubyMalClient::AuthenticatedUser.new
anime = RubyMalClient::Anime.new

puts "Please grant access to your profile by using the following url: #{user.authorization_url}"
puts "Once you have granted access please paste your access code here:"
auth_code = gets.chomp.to_s
user.authorize(auth_code)

puts "Welcome #{user.user[:name]}"

puts "Your user information"
p user.current_user

puts "Anime list:"
p user.my_anime_list

puts "Anime details:"
p anime.find("30230")

puts "Anime Ranking:"
p anime.ranking

puts "Seasonal anime:"
p anime.seasonal

puts "Adding entry to your list"
random_anime_id = "6347" # Baka to test
random_anime_info = {
  status: RubyMalClient::Configurations::ANIME_LIST_ITEM_STATUSES[:watching],
  num_watched_episodes: 1,
  comments: "this record was added using RubyMALClient"
}
p user.upsert_anime_to_list(random_anime_id, random_anime_info)

puts "Deleting entry from your list"
p user.delete_anime_from_list(random_anime_id)

puts "Other user\'s anime list"
p anime.list_for("SentenceBox")
