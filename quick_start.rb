# frozen_string_literal: true

require "ruby_mal_client"

RubyMalClient.configure do |config|
  config.client_id = "Your Client ID goes here..."
  config.client_secret = "Your Client Secret goes here..."
end

user = RubyMalClient::AuthenticatedUser.new
anime = RubyMalClient::Anime.new
manga = RubyMalClient::Manga.new
forum = RubyMalClient::Forum.new

puts "Please grant access to your profile by using the following url: #{user.authorization_url}"
puts "Once you have granted access please paste your access code here:"
auth_code = gets.chomp.to_s
user.authorize!(auth_code)

puts "Welcome #{user.current_user[:name]}"

=begin
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
# The following anime id corresponds to "Baka to test", if you already have it registered in your list, be careful with the following methods
random_anime_id = "6347" #baka to test
random_anime_info = {
  status: "watching",
  num_watched_episodes: 1,
  comments: "this record was added using RubyMALClient"
}
p user.upsert_anime_to_list(random_anime_id, random_anime_info)

puts "Deleting entry from your list"
p user.delete_anime_from_list(random_anime_id)

puts "Other user\'s anime list"
p anime.list_for("SentenceBox")
=end
p "Other user\'s manga list"
p manga.list_for("SentenceBox")

p "Manga ranking"
p manga.ranking

p "Manga details"
p manga.find("39419")

p "Your manga list"
p user.my_manga_list

p "Adding record to your manga list"
random_manga_id = "39419" #Lovely complex
random_manga_info = {
  status: "reading",
  num_chapters_read: 1,
  comments: "this record was added using RubyMALClient"
}
p user.upsert_manga_to_list(random_manga_id, random_manga_info)

#p "Deleting record from your manga list"

p "Forum boards"
p forum.boards

p "Forum topics"
p forum.topics("5")

p "Forum topic details"
p forum.topic_details("1979258")