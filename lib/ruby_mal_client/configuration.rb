# frozen_string_literal: true

module RubyMalClient
  class Configuration
    # Others
    ANIME_DETAILS_FIELDS = %w[
      id title main_picture alternative_titles start_date end_date
      synopsis mean rank popularity num_list_users num_scoring_users
      nsfw created_at updated_at media_type status genres
      num_episodes start_season broadcast source average_episode_duration
      rating pictures background related_anime related_manga recommendations
      studios statistics
    ].freeze

    SEASONS_MONTHS = {
      winter: %w[January February March],
      spring: %w[April May June],
      summer: %w[July August September],
      fall: %w[October November December]
    }.freeze

    attr_accessor :client_id, :client_secret

    def self.formatted_anime_details_fields(fields = [])
      fields = ANIME_DETAILS_FIELDS if fields.empty?
      fields.join(",")
    end

    def credentials?
      !client_id.nil? && !client_secret.nil?
    end
  end
end
