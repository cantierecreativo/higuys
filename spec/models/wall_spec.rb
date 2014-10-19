require 'rails_helper'

RSpec.describe Wall do
  describe '.inactive_since' do
    let(:wall) { create(:wall) }
    let(:guest) { create(:guest, wall: wall) }
    let(:image) { create(:image, guest: guest, image_path: 'foobar.jpg') }

    context 'if an user of the wall was active more than 48 hours ago' do
      before do
        image.created_at = 50.hours.ago
        guest.last_image = image
        image.save
        guest.save
      end

      it 'is returned' do
        expect(Wall.inactive_since(48.hours)).to eq([wall])
      end
    end

    context 'else' do
      before do
        image.created_at = 24.hours.ago
        guest.last_image = image
        image.save
        guest.save
      end

      it 'is returned' do
        expect(Wall.inactive_since(48.hours)).to eq([])
      end
    end
  end
end

