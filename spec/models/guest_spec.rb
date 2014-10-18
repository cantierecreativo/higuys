require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe '.by_id' do
    let(:guest1) { create(:guest) }
    let(:guest2) { create(:guest) }

    before do
      guest1
      guest2
    end

    it 'returns the guest ordere by id in ascending order' do
      expect(Guest.by_id).to eq([guest1, guest2])
    end
  end
end
