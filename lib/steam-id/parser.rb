# coding: utf-8

require 'steam-condenser'

module SteamID
  # Create SteamID objects based on numeric or string-based Steam ID inputs.
  # @see SteamID
  class Parser
    STEAM_CUSTOM_URL_BASE = 'https://steamcommunity.com/id/%s'

    # Pattern to match classical Steam IDs (STEAM_0:...)
    PATTERN_STEAM_ID = /^STEAM_[0-9]:([0-9]):([0-9]+)$/i
    # Pattern to match Steam ID 3 format ([U:1:...])
    PATTERN_STEAM_ID_3 = /^\[?U:([0-9]{1,2}):([0-9]+)\]?$/i
    # Pattern to match Steam ID 64 aka profile ID format (765...):
    # Must have at least 14 digits, else ID_64 - OFFSET would be < 0.
    PATTERN_STEAM_ID_64 = /^(765[0-9]{11,})$/
    # Pattern to match plain account IDs.
    # Not sure what its valid range is - exists with at least 7 and 8 numbers.
    PATTERN_ACCOUNT_ID = /^[0-9]+$/

    # Pattern to match ID64-based profile URLs.
    PATTERN_COMMUNITY_URL = /^https?:\/\/steamcommunity\.com\/profiles\/(765[0-9]{11,})\/?$/
    # Pattern to match ID3-based profile URLs.
    PATTERN_COMMUNITY_URL_STEAM_ID_3 = /^https?:\/\/steamcommunity\.com\/profiles\/\[U:([0-9]{1,2}):([0-9]+)\]$/i
    # Pattern to match custom-URL-based profile URLs.
    PATTERN_CUSTOM_URL = /^https?:\/\/steamcommunity\.com\/id\/([^\/]+)\/?$/

    # Initialize parser
    # @param api_key [String] Key for Steam web API. `nil` to disable API
    #   functionality.
    def initialize(api_key: nil)
      @api_key = api_key
      if api_key
        ::WebApi.api_key = @api_key.to_s
      end
    end

    # Create SteamID object based on any kind of recognized Steam ID.
    # @param s [String]: Any form of known Steam ID, profile URL, or 'vanity'/
    #   custom URL.
    # @see Parser#from_steam_id Supported formats of Steam IDs
    # @see Parser#from_community_url Supported formats of community URLs
    # @see Parser#from_vanity_url Supported formats of vanity URLs
    # @return [SteamID]
    # @raise [ArgumentError] If the supplied string was not a valid custom URL.
    # @raise [WebApiError] If the Steam API returned an error.
    def from_string(s)
      account_id = nil

      # Todo: Refactor
      begin
        # Checking for Steam ID first. Most restrictive check, and also does
        # not require a call to Steam Web API.
        account_id = from_steam_id(s)
      rescue ArgumentError
        begin
          # Community URL afterwards, does not require an API call either.
          account_id = from_community_url(s)
        rescue ArgumentError
          begin
            # Trying to resolve as custom/vanity URL now.
            account_id = from_vanity_url(s)
          rescue ArgumentError
          end
        end
      end

      if account_id.nil?
        raise ArgumentError, "Could not convert #{ s } to account id."
      else
        account_id
      end
    end

    # Create SteamID object based on Steam ID.
    # @param id [String] Steam ID, either of:
    #   - Steam ID: STEAM_0:0:24110655
    #   - Steam ID 3: U:1:48221310
    #   - Steam ID 64: 76561198008487038
    #   - Account ID: 48221310
    # @return [SteamID]
    # @raise [ArgumentError] If the supplied string could not be converted to
    #   an account ID.
    def from_steam_id(id)
      # In case we get a fixnum.
      id = id.to_s

      # https://developer.valvesoftware.com/wiki/SteamID#Format
      PATTERN_STEAM_ID.match(id) do |m|
        return SteamID.new(m[1].to_i + m[2].to_i * 2)
      end

      PATTERN_STEAM_ID_3.match(id) do |m|
        return SteamID.new(m[2].to_i)
      end

      PATTERN_STEAM_ID_64.match(id) do |m|
        return SteamID.new(m[1].to_i - SteamID::ID_64_OFFSET)
      end

      # Matching this one last, as not to catch an ID 64 on accident.
      PATTERN_ACCOUNT_ID.match(id) do |m|
        return SteamID.new(id.to_i)
      end

      # If we get until here, we did not match any regex.
      raise ArgumentError, "#{ id.inspect } is not a supported SteamID."
    end

    # Create SteamID object based on community URL.
    # @param url [String] community URL: http://steamcommunity.com/profiles/76561198008487038
    # @return [SteamID]
    # @raise [ArgumentError] If the supplied string was not a valid community URL.
    def from_community_url(url)
      PATTERN_COMMUNITY_URL.match(url) do |m|
        return self.from_steam_id(m[1])
      end

      PATTERN_COMMUNITY_URL_STEAM_ID_3.match(url) do |m|
        return self.from_steam_id(m[2])
      end

      raise ArgumentError, "#{ url.inspect } is not a supported community URL."
    end

    # Create SteamID object based on custom URL. Note that this requires the
    # API key to be set.
    # @param url [String] custom URL - must be ASCII: 
    #   - http://steamcommunity.com/id/some-custom-url
    #   - some-custom-url
    # @return [SteamID]
    # @raise [ArgumentError] If the supplied string was not a valid custom URL.
    # @raise [WebApiError] If the Steam API returned an error.
    def from_vanity_url(url)
      PATTERN_CUSTOM_URL.match(url) do |m|
        url = m[1]
      end

      begin
        URI(STEAM_CUSTOM_URL_BASE % url)
      rescue URI::InvalidURIError
        raise ArgumentError, "#{ url } can't be part of a valid URI."
      end

      steam_id = SteamId.resolve_vanity_url(url)
      if steam_id.nil?
        raise ArgumentError, "#{ url } was not a valid custom URL."
      else
        from_steam_id(steam_id)
      end
    end
  end
end
