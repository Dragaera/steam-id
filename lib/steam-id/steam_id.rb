# coding: utf-8

module SteamID
  # Class representing a single Steam ID - that is, one logical account
  class SteamID
    # Offset between ID 64 and account ID.
    ID_64_OFFSET = 76561197960265728
    # Base URL for Steam community profiles based on ID64 / ID3.
    PROFILE_BASE_URL = "https://steamcommunity.com/profiles"

    attr_reader :account_id

    # Create new SteamID
    # @param account_id [Integer] Numeric account ID.
    def initialize(account_id)
      @account_id = account_id
    end

    # @return [String] Classical Steam ID (eg STEAM_0:....)
    def id
      offset = @account_id / 2
      index  = @account_id - 2 * offset

      "STEAM_0:#{ index }:#{ offset }"
    end

    # @return [Integer] Steam ID 64 / Steam profile ID (eg 765...)
    def id_64
      @account_id + ID_64_OFFSET
    end

    # @return [String] Steam ID 3 (eg [U:1:...])
    def id_3
      "[U:1:#{ @account_id }]"
    end

    # @return [String] URL to player's profile on Steam community.
    def profile_url
      "#{ PROFILE_BASE_URL }/#{ id_64 }"
    end
  end
end
