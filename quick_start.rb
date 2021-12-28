require "ruby_mal_client"

MAL_CLIENT_ID = "ab75fe72617c2d1ab411e46bb31c144f"
MAL_CLIENT_SECRET = "38b7e9b0a3398486f06f201904fa3622c7f19f66809fc98b1d2c8e362c3276da"

RubyMalClient.configurations.client_id = MAL_CLIENT_ID

simple_mal_client = RubyMalClient::SimpleMALClient.new

puts "Anime list:"
puts simple_mal_client.get_anime_list("michael_apl")

puts "Anime details:"
anime_detail_fields = RubyMalClient::Configurations.anime_details_fields
puts simple_mal_client.get_anime_details("30230", anime_detail_fields)

puts "Anime Ranking:"
puts simple_mal_client.get_anime_ranking

puts "Seasonal anime:"
puts simple_mal_client.get_seasonal_anime
#puts "Please grant access to your profile by using the following url: #{anime_list.auth_url}"
#puts "Once you have granted access please paste your access code here:"
#auth_code = gets.chomp.to_s

#user = mal_client.get_user_info
#puts "Welcome #{user[:name]}"