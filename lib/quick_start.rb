require "ruby_mal_client"

RubyMalClient.configurations.client_id = "ab75fe72617c2d1ab411e46bb31c144f"

simple_mal_client = RubyMalClient::SimpleMALClient.new

puts simple_mal_client.get_anime_list("michael_apl")

#puts "Please grant access to your profile by using the following url: #{anime_list.auth_url}"
#puts "Once you have granted access please paste your access code here:"
#auth_code = gets.chomp.to_s

#user = mal_client.get_user_info
#puts "Welcome #{user[:name]}"