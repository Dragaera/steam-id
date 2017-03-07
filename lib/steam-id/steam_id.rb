require 'steam-condenser'

module SteamID
  # Module to convert various formats of Steam IDs into an account ID.
  module SteamID
    STEAM_ID_64_OFFSET = 61197960265728

    PATTERN_STEAM_ID = /^STEAM_[0-9]:([0-9]):([0-9]+)$/i
    PATTERN_STEAM_ID_3 = /^\[?U:([0-9]{1,2}):([0-9]+)\]?$/i
    # Must be at least 14 numbers, else ID_64 - OFFSET would be < 0.
    PATTERN_STEAM_ID_64 = /^765([0-9]{11,})$/
    # Not sure what its valid range is - exists with at least 7 and 8 numbers.
    PATTERN_ACCOUNT_ID = /^[0-9]+$/

    PATTERN_COMMUNITY_URL = /^https?:\/\/steamcommunity\.com\/profiles\/(765[0-9]+)\/?$/
    PATTERN_CUSTOM_URL = /^https?:\/\/steamcommunity\.com\/id\/([^\/]+)\/?$/

    # Resolve custom URL into account ID suitable for API calls.
    # @param s [String] custom URL: 
    #   - http://steamcommunity.com/id/some-custom-url
    #   - some-custom-url
    # @return [Fixnum] Account ID
    # @raise [ArgumentError] If the supplied string was not a valid community URL.
    def self.from_vanity_url(url, steam_api_key:)
      WebApi.api_key = steam_api_key

      PATTERN_CUSTOM_URL.match(url) do |m|
        url = m[1]
      end

      steam_id = SteamId.resolve_vanity_url(url)
      if steam_id.nil?
        raise ArgumentError, "#{ url } was not a valid custom URL."
      else
        from_steam_id(steam_id)
      end
    end

    # Convert community URL into account ID suitable for API calls.
    # @param s [String] community URL: http://steamcommunity.com/profiles/76561198008487038
    # @return [Fixnum] Account ID
    # @raise [ArgumentError] If the supplied string was not a valid community URL.
    def self.from_community_url(url)
      PATTERN_COMMUNITY_URL.match(url) do |m|
        return self.from_steam_id(m[1])
      end

      raise ArgumentError, "#{ url.inspect } is not a supported community URL."
    end

    # Convert Steam ID into account ID suitable for API calls.
    # @param s [String] Steam ID, either of:
    #   - Steam ID: STEAM_0:0:24110655
    #   - Steam ID 3: U:1:48221310
    #   - Steam ID 64: 76561198008487038
    #   - Account ID: 48221310
    # @return [Fixnum] Account ID
    # @raise [ArgumentError] If the supplied string could not be converted to
    #   an account ID.
    def self.from_steam_id(id)
      # In case we get a fixnum.
      id = id.to_s

      # https://developer.valvesoftware.com/wiki/SteamID#Format
      PATTERN_STEAM_ID.match(id) do |m|
        return m[1].to_i + m[2].to_i * 2
      end

      PATTERN_STEAM_ID_3.match(id) do |m|
        return m[2].to_i
      end

      PATTERN_STEAM_ID_64.match(id) do |m|
        return m[1].to_i - STEAM_ID_64_OFFSET
      end

      # Matching this one last, as not to catch an ID 64 on accident.
      PATTERN_ACCOUNT_ID.match(id) do |m|
        return id.to_i
      end

      # If we get until here, we did not match any regex.
      raise ArgumentError, "#{ id.inspect } is not a supported SteamID."
    end

    def self.from_string(s, steam_api_key: nil)
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
            account_id = from_vanity_url(s, steam_api_key: steam_api_key)
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
  end
end
