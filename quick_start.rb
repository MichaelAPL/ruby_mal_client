require "ruby_mal_client"

MAL_CLIENT_ID = "ab75fe72617c2d1ab411e46bb31c144f"
MAL_CLIENT_SECRET = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"

RubyMalClient.configurations.client_id = MAL_CLIENT_ID
RubyMalClient.configurations.client_secret = MAL_CLIENT_SECRET

mal_client = RubyMalClient::MALClient.new

puts "Please grant access to your profile by using the following url: #{mal_client.mal_authorization_url}"
puts "Once you have granted access please paste your access code here:"
auth_code = gets.chomp.to_s
mal_client.authorize(auth_code)

puts "Welcome #{mal_client.user[:name]}"

puts "Your user information"
p mal_client.user

puts "Anime list:"
p mal_client.get_anime_list

puts "Anime details:"
anime_detail_fields = RubyMalClient::Configurations.anime_details_fields
p mal_client.get_anime_details("30230", anime_detail_fields)

puts "Anime Ranking:"
p mal_client.get_anime_ranking

puts "Seasonal anime:"
p mal_client.get_seasonal_anime

puts "Adding entry to your list"
random_anime_id = "6347" #Baka to test
random_anime_info = {
    status: RubyMalClient::Configurations::ANIME_LIST_ITEM_STATUSES[:watching],
    num_watched_episodes: 1,
    comments: "this record was added using RubyMALClient"
}
p mal_client.add_or_update_anime_to_list(random_anime_id, random_anime_info)

puts "Deleting entry from your list"
p mal_client.delete_anime_from_list(random_anime_id)

puts "Other user\'s anime list"
p mal_client.get_anime_list(username: "SentenceBox")

