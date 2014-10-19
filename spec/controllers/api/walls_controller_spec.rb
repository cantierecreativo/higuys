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
      post :create_upload_policy, format: :json
    }

    before do
      allow(policy_generator).to receive(:execute) { 'URL' }
    end

    context 'with a non authenticated user' do
      before { action }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'with a user user signed in (associated with a wall)' do
      let(:session_manager) { instance_double("SessionManager") }
      let(:user) { create(:guest, :with_wall) }
      let(:wall) { user.wall }

      before do
        allow(SessionManager).to receive(:new).with(session) { session_manager }
        allow(session_manager).to receive(:current_user) { user }
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
    let(:action) {
      post :create_photo, { s3_url: 'URL', format: :json }
    }

    context 'with a non authenticated user' do
      before { action }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'with a user user signed in (associated with a wall)' do
      let(:session_manager) { instance_double("SessionManager") }
      let(:user) { create(:guest, :with_wall) }
      let(:wall) { user.wall }

      before do
        allow(SessionManager).to receive(:new).with(session) { session_manager }
        allow(session_manager).to receive(:current_user) { user }
      end

      before do
        allow(store_photo).to receive(:execute)
      end

      before do
        action
      end

      it 'notify all the other clients that I have uploaded a photo' do
        expect(store_photo).to have_received(:execute).with(user, 'URL')
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
      get :show, { format: :json }
    end

    context 'with a non authenticated user' do
      before { action }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'with a user user signed in (associated with a wall)' do
      let(:session_manager) { instance_double("SessionManager") }
      let(:image) { create(:image) }
      let(:user) { image.user }

      before do
        allow(SessionManager).to receive(:new).with(session) { session_manager }
        allow(session_manager).to receive(:current_user) { user }
      end

      before do
        user.wall = wall
        user.last_image = image
        user.save!
      end

      before do
        action
      end

      it 'returns a json with all users of this wall and their photos' do
        expect(response.body).to have_json_size(1)
        expect(response.body).to include_json({id: user.id,
                                               image_url: user.last_image.imgx_url,
                                               active_at: user.last_image.created_at,
                                               status_message: "a status message",
                                              }.to_json)
      end
    end
  end

  describe "PUT #status" do
    let(:old_status_message) { 'a_status_message' }
    let(:new_status_message) { 'another_status' }

    let(:wall) { create(:wall) }
    let(:action) do
      put :status, { format: :json , status_message: new_status_message }
    end

    context 'with a non authenticated user' do
      before { action }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end

    context 'with a user user signed in (associated with a wall)' do
      let(:session_manager) { instance_double("SessionManager") }
      let(:user) { create(:guest) }

      before do
        allow(SessionManager).to receive(:new).with(session) { session_manager }
        allow(session_manager).to receive(:current_user) { user }
      end

      before do
        user.wall = wall
        user.save!
      end

      before do
        action
      end

      it 'returns a json with all users of this wall and their photos' do
        expect(response.body).to have_json_size(2)
        expect(response.body).to eq({id: user.id, status_message: new_status_message }.to_json)
      end
    end
  end
end

