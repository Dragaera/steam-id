module SteamID
  RSpec.describe SteamID do
    STEAM_ID         = 'STEAM_0:0:24110655'
    STEAM_ID_MIXED   = 'SteAM_0:0:24110655'
    STEAM_ID_SHORT   = 'STEAM_1:0:2691362'

    STEAM_ID_3       = 'U:1:48221310'
    STEAM_ID_3_LOWER = 'u:1:48221310'
    STEAM_ID_3_SHORT = 'U:1:4584616'

    STEAM_ID_64      = '76561198008487038'

    COMMUNITY_URL = 'http://steamcommunity.com/profiles/76561198008487038'

    describe '::from_steam_id' do
      it 'supports SteamID as input' do
        steam_id = SteamID.from_steam_id(STEAM_ID)
        expect(steam_id).to eq 48221310

        steam_id = SteamID.from_steam_id(STEAM_ID_SHORT)
        expect(steam_id).to eq 5382724
      end

      it 'supports SteamID 3 as input' do
        steam_id = SteamID.from_steam_id(STEAM_ID_3)
        expect(steam_id).to eq 48221310

        steam_id = SteamID.from_steam_id(STEAM_ID_3_SHORT)
        expect(steam_id).to eq 4584616
      end

      it 'is not case-sensitive' do
        steam_id = SteamID.from_steam_id(STEAM_ID_MIXED)
        expect(steam_id).to eq 48221310

        steam_id = SteamID.from_steam_id(STEAM_ID_3_LOWER)
        expect(steam_id).to eq 48221310
      end


      it 'supports SteamID 64 as input' do
        steam_id = SteamID.from_steam_id(STEAM_ID_64)
        expect(steam_id).to eq 48221310
      end

      it 'supports an account ID as input' do
        steam_id = SteamID.from_steam_id(48221310)
        expect(steam_id).to eq 48221310

        # Special case, starts with 765, like a Steam ID
        steam_id = SteamID.from_steam_id(7654321)
        expect(steam_id).to eq 7654321
      end

      it 'raises an exception upon invalid input' do
        expect { SteamID.from_steam_id('foobar') }.to raise_error(ArgumentError)
      end
    end

    describe '::from_community_url' do
      it 'supports community URLs as input' do
        steam_id = SteamID.from_community_url(COMMUNITY_URL)
        expect(steam_id).to eq 48221310
      end

      it 'raises an exception upon invalid input' do
        expect { SteamID.from_community_url('http://google.com/profiles/foo') }.to raise_error(ArgumentError)
      end
    end

    describe '::from_vanity_url' do
      it 'supports custom URLs as input' do
          expect(::SteamId).to receive(:resolve_vanity_url) { 54321 }
          expect(SteamID).to receive(:from_steam_id) { 12345 }

          expect(SteamID.from_vanity_url('some-test', steam_api_key: nil)).to eq 12345
      end

      it 'supports full custom URLs as input' do
          expect(::SteamId).to receive(:resolve_vanity_url) { 54321 }
          expect(SteamID).to receive(:from_steam_id) { 12345 }

          expect(SteamID.from_vanity_url('http://steamcommunity.com/id/some-test', steam_api_key: nil)).to eq 12345
      end

      it 'raises an exception if it could not resolve the ID' do
          expect(::SteamId).to receive(:resolve_vanity_url) { nil }

          expect{ SteamID.from_vanity_url('this-better-not-be-a-valid-url', steam_api_key: nil) }.to raise_error(ArgumentError)
      end
    end
  end
end
