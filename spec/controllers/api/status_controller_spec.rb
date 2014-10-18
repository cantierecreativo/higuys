require 'rails_helper'

describe Api::StatusController do
  render_views

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
      get :index, { wall_id: wall.access_code, format: :json }
    end

    it 'returns a json with all guests of this wall and their photos' do
      expect(response.body).to have_json_size(1)
      expect(response.body).to include_json({id: guest.id,
                                             image_url: guest.last_image.imgx_url,
                                             active_at: guest.last_image.created_at,
                                            }.to_json)
    end
  end
end
