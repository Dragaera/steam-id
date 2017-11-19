# coding: utf-8

RSpec.describe SteamID do
  describe '#from_string' do
    it 'should resolve the ID into a string' do
      expect(SteamID.from_string('STEAM_0:0:24110655').account_id).to eq 48221310
    end
  end
end
