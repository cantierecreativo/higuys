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

  describe '.active' do
    let(:guest1) { create(:guest) }
    let(:guest2) { create(:guest) }
    let(:image1) { create(:image, guest: guest1, image_path: 'foobar.jpg') }
    let(:image2) { create(:image, guest: guest2, image_path: 'foobaz.jpg') }

    before do
      image1.created_at = 10.minutes.ago
      image2.created_at = 2.minutes.ago
      guest1.last_image = image1
      guest2.last_image = image2

      image1.save
      image2.save
      guest1.save
      guest2.save
    end

    it 'returns only the guests with a photo taken less than 5 minutes ago' do
      expect(Guest.active).to eq([guest2])
    end
  end
end
