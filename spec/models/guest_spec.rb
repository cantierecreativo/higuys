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

  describe '.active_in_the_last' do
    let(:guest) { create(:guest) }
    let(:image) { create(:image, guest: guest, image_path: 'foobar.jpg') }

    context 'if the guest was active less than 5 minutes ago' do
      before do
        image.created_at = 3.minutes.ago
        guest.last_image = image
        image.save
        guest.save
      end

      it 'is returned' do
        expect(Guest.active_in_the_last(5.minutes)).to eq([guest])
      end
    end

    context 'else' do
      before do
        image.created_at = 10.minutes.ago
        guest.last_image = image
        image.save
        guest.save
      end

      it 'is not returned' do
        expect(Guest.active_in_the_last(5.minutes)).to eq([])
      end
    end
  end
end
