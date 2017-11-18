module SteamID
  RSpec.describe SteamID do
    let(:steam_id) { SteamID.new(48221310) }

    describe '#account_id' do
      it 'should return the account ID' do
        expect(steam_id.account_id).to eq 48221310
      end
    end

    describe '#id' do
      it 'should return the Steam ID' do
        expect(steam_id.id).to eq 'STEAM_0:0:24110655'
      end
    end

    describe '#id_64' do
      it 'should return the Steam ID 64' do
        expect(steam_id.id_64).to eq 76561198008487038
      end
    end

    describe '#id_3' do
      it 'should return the Steam ID 3' do
        expect(steam_id.id_3).to eq '[U:1:48221310]'
      end
    end

    describe '#profile_url' do
      it 'should return the profile URL' do
        expect(steam_id.profile_url).to eq 'https://steamcommunity.com/profiles/76561198008487038'
      end
    end
  end
end
