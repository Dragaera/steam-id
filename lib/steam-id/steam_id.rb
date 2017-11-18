# coding: utf-8

module SteamID
  class SteamID
    ID_64_OFFSET = 61197960265728
    PROFILE_BASE_URL = "https://steamcommunity.com/profiles"

    attr_reader :account_id

    def initialize(account_id)
      @account_id = account_id
    end

    def id
      offset = @account_id / 2
      index  = @account_id - 2 * offset

      "STEAM_0:#{ index }:#{ offset }"
    end

    def id_64
      "765#{ @account_id + ID_64_OFFSET }".to_i
    end

    def id_3
      "[U:1:#{ @account_id }]"
    end

    def profile_url
      "#{ PROFILE_BASE_URL }/#{ id_64 }"
    end
  end
end
