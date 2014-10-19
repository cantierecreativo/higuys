require 'rails_helper'

AwsPolicyGenerator
StorePhoto

describe Api::WallsController do
  render_views

  before do
    stub_const 'ENV', { 'IMGX_URL' => 'http://foobar.imgx.com/' }
  end

  describe 'POST :create_upload_policy' do
    let(:wall) { create(:wall) }
    let(:policy_generator) {
      class_double('AwsPolicyGenerator')
        .as_stubbed_const(transfer_nested_constants: true)
    }
    let(:action) {
      post :create_upload_policy, format: :json, wall_id: wall.access_code
    }

    before do
      allow(policy_generator).to receive(:execute) { 'URL' }
    end

    context 'with a non authenticated guest' do
      before { action }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'with a guest user signed in (associated with a wall)' do
      let(:session_manager) { instance_double("SessionManager") }
      let(:guest) { create(:guest, :with_wall) }

      before do
        allow(SessionManager).to receive(:new).with(session) { session_manager }
        allow(session_manager).to receive(:current_guest) { guest }
      end

      before { action }

      it 'responds with ok' do
        expect(response.status).to eq(200)
      end

      it 'returns an hash with an url and a request id' do
        expect(response.body).to eq({ upload_url: 'URL' }.to_json)
      end
    end
  end

  describe 'POST :create_photo' do
    let(:store_photo) {
      class_double("StorePhoto")
        .as_stubbed_const(transfer_nested_constants: true)
    }
    let(:wall) { create(:wall) }
    let(:action) { post :create_photo, { s3_url: 'URL', format: :json, wall_id: wall.access_code } }

    context 'with a non authenticated guest' do
      before { action }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'with a guest user signed in (associated with a wall)' do
      let(:session_manager) { instance_double("SessionManager") }
      let(:guest) { create(:guest, :with_wall) }

      before do
        allow(SessionManager).to receive(:new).with(session) { session_manager }
        allow(session_manager).to receive(:current_guest) { guest }
      end

      before do
        allow(store_photo).to receive(:execute)
      end

      before do
        action
      end

      it 'notify all the other clients that I have uploaded a photo' do
        expect(store_photo).to have_received(:execute)
          .with(guest, 'URL')
      end

      it 'responds with ok' do
        expect(response.status).to eq(200)
      end
    end

    context 'on StorePhotoInvalidInputException' do
      before do
        allow(store_photo).to receive(:execute).
          and_raise(StorePhoto::InvalidInputException)
      end

      before do
        action
      end

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'GET #show' do
    let(:wall) { create(:wall) }
    let(:action) do
      get :show, { wall_id: wall.access_code, format: :json }
    end

    context 'with a non authenticated guest' do
      before { action }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'with a guest user signed in (associated with a wall)' do
      let(:session_manager) { instance_double("SessionManager") }
      let(:image) { create(:image) }
      let(:guest) { image.guest }

      before do
        allow(SessionManager).to receive(:new).with(session) { session_manager }
        allow(session_manager).to receive(:current_guest) { guest }
      end

      before do
        guest.wall = wall
        guest.last_image = image
        guest.save!
      end

      before do
        action
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
end

