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

  describe '#to_json' do
    let(:image) { create(:image, guest: guest) }
    let(:guest) { create(:guest) }

    before do
      stub_const 'ENV', { 'IMGX_URL' => 'http://foobar.imgx.com/' }
    end

    context 'if it has a last image' do
      before do
        guest.last_image = image
      end

      it 'returns the id of the guest and the url of its last image' do
        expect(guest.to_json).to eq({id: guest.id, image_url: image.imgx_url})
      end
    end

    context 'else' do
      it 'returns the id of the guest and nil as the url of its last image' do
        expect(guest.to_json).to eq({id: guest.id, image_url: nil})
      end
    end
  end
end
