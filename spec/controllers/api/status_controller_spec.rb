require 'rails_helper'

describe Api::StatusController do
  let(:wall) { create(:wall) }
  let(:guest) { create(:guest, wall: wall) }
  let(:image) { create(:image, guest: guest) }

  before do
    stub_const 'ENV', { 'IMGX_URL' => 'http://foobar.imgx.com/' }
  end

  describe 'GET #index' do
    before do
      guest.last_image = image
      guest.save!
    end

    before do
      get :index, { wall_id: wall.access_code }
    end

    it 'returns a json representing the guest of this wall and their photos' do
      expect(response.body).to eq([{ id: guest.id, image_url: guest.last_image.imgx_url }].to_json)
    end
  end
end
