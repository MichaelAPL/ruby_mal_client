# RubyMalClient

Welcome to RubyMalClient, a client for connecting and retrieving information from the [MyAnimeList.net official API](https://myanimelist.net/apiconfig/references/api/v2).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_mal_client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby_mal_client

## Usage

The very first thing you need to do in order to use this gem is to request a `Client ID` and `Client Secret` for your application to use from MyAnimeList.net, you can request them [here](https://myanimelist.net/apiconfig/create) (Note that you have to be a registered MAL user).

### DON'T TRY TO USE THE CREDENTIALS USED IN THIS REPOSITORY

Those credentials were only used for testing and to generate web mocks, they are no longer active, you have to fill the MAL form provided above to generate your own credentials.

### DON'T REFERENCE THIS PROJECT AS THE APPLICATION REQUESTED IN THE MAL API REQUEST FORM

This gem is meant to be used as an in-between between the MyAnimeList.net official API and your own project, so don't reference it in neither the `App Redirect URL` or the `Homepage URL` form fields of the MAL API access request form.

### Once you have generated your Client ID and Client Secret

Just set them in the gem configurations as shown here:

```ruby
RubyMalClient.configure do |config|
  config.client_id = "Your Client ID goes here..."
  config.client_secret = "Your Client Secret goes here..."
end
```

If you only want to access to anime, manga, lists and forums without modifying lists you can just set the Client ID into the configurations and you should be able to use the `Anime`, `Manga` and `Forums` classes.

## Anime 

| Method name      | Function |
| -----------      | ----------- |
| all              | Brings back all the posible amount of records (see the params fields for more info at the api doc)      |
| list_for         | Brings back the anime list of the specified user      |
| find             | Brings the details of the specified anime by passing the anime_id        |
| ranking          | Brings back the anime ranking      |
| seasonal         | Brings back the aired anime for the year and season provided in the params (if no params are specified, it will bring the current season animes)      |

Example of use:

```ruby
anime = RubyMalClient::Anime.new

#Anime list:
params = { fields: "list_status", limit: "100", status: "completed" }
anime.list_for("michael_apl", params)

#Anime details:
anime.find("30230")

#Anime Ranking (Top):
anime.ranking

#Seasonal anime:
anime.seasonal
```
Note that for the `params` you can send them just as they are defined at the official MAL API documentation, you can check it [here](https://myanimelist.net/apiconfig/references/api/v2#section/Common-parameters).

DEVELOPER NOTE: for the `fields` param, there are actually a lot of fields that can be sended, all of them are sent in the find method, as most of these are not (up to this date) specified in the API documentation, I gathered all the fields I was able to find and set them at the `RubyMALClient::Configuration::ANIME_DETAILS_FIELDS`. You can either take them all or modify the params fields with the ones you consider necessary.

## User Authentication

In order to be able to access to your profile and modify your lists you will have to grant authorization to your MAL profile.

You can do this by using the `AuthenticatedUser` class

```ruby
user = RubyMalClient::AuthenticatedUser.new
```
First you need to access to the `authorization url` in your browser and grant access to your application, this URL is provided in the following method

```ruby
user.authorization_url
```

This URL will take you to a MAL modal asking you for your confirmation, once you confirm the authorization, it will redirect you to your application URL (the one you provided in the `Homepage URL` field), however, the URL will contain a special parameter called `code`, it is a very long string that starts with something like `def50200c0687cfa2678e250...`, you have to get the value of that parameter and send it to the `authorize!` method

```ruby
auth_code = "def50200c0687cfa2678e250..." #auth code goes here
user.authorize!(auth_code)
```

MAL API's access token has an expiration time, when the access token expires, an exception will be throwed, in that case, just use the `renovate_authorization!` method.

```ruby
user.renovate_authorization!
```

Now you can access the methods provided by the `AuthenticatedUser` class for retrieving info:

| Method name              | Function |
| -----------              | ----------- |
| my_anime_list            | Brings the anime list of the authenticated user      |
| current_user             | Brings the profile info of the authenticated user      |
| suggested_anime          | Brings the suggested anime section for the authenticated user      |
| upsert_anime_to_list     | add or update an anime to the authenticated user's anime list      |
| delete_anime_from_list   | delete an anime from the authenticated user's anime list      |

<!---| full_list            | Brings either the anime or manga FULL list of the authenticated user without pagination     |-->

Example of use:

```ruby
#User info
user.current_user

#User anime list
user.my_anime_list

#Adding a new entry to the list
random_anime_id = "6347" # Baka to test
random_anime_info = {
  status: RubyMalClient::Configuration::ANIME_LIST_ITEM_STATUSES[:watching],
  num_watched_episodes: 1,
  comments: "this record was added using RubyMALClient"
}
user.upsert_anime_to_list(random_anime_id, random_anime_info)
#If the entry already exist in the list, it will be updated with the info sent in params

#Deleting entry from your list
user.delete_anime_from_list(random_anime_id)
```

## Manga

```ruby
manga = RubyMalClient::Manga.new
```

| Method name      | Function |
| -----------      | ----------- |
| all              | Brings back all the posible amount of records (see the params fields for more info at the api doc)      |
| list_for         | Brings back the manga list of the specified user      |
| find             | Brings the details an specified manga by passing the manga_id        |
| ranking          | Brings back the MAL manga ranking (see the api doc for applying filters with the params)     |

## Forum

```ruby
forum = RubyMalClient::Forum.new
```

| Method name   | Notes |
| -----------   | ----------- |
| boards        |       |
| topics        | I implemented so it requires a board_id, otherwise it takes so long trying to retrieve all topics that it may cause a timeout      |
| topic_details |  |

## Quickstart
You can check and run the `quickstart.rb` file for a sumarized and complete use of the gem classes and flow

    $ rb quick_start.rb

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MichaelAPL/ruby_mal_client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/MichaelAPL/ruby_mal_client/blob/master/CODE_OF_CONDUCT.md).

You can also send me a direct message to my [MAL profile](https://myanimelist.net/profile/Michael_APL).

Infinite thanks to [@3zcurdia](https://github.com/3zcurdia) for his tips and contributions to the creation of this gem <3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RubyMalClient project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/MichaelAPL/ruby_mal_client/blob/master/CODE_OF_CONDUCT.md).
