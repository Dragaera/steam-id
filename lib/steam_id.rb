# coding: utf-8

require 'steam-id/steam_id'
require 'steam-id/parser'

# Handle Steam IDs.
module SteamID
  # Create SteamID object based on Steam ID.
  # @param s [String] Steam ID which to use.
  # @param api_key (see Parser#initialize)
  # @return [SteamID]
  # @see Parser#from_string Supported formats of Steam ID.
  # @example
  #   id1 = SteamID.from_string('STEAM_0:0:24110655')
  #   id2 = SteamID.from_string('gabenewell', api_key: '...')
  #   puts "Accounts are equal: #{ id1.account_id == id2.account_id }"
  def from_string(s, api_key: nil)

  end
end
