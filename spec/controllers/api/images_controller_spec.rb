require 'rails_helper'

AwsPolicyGenerator
StorePhoto

describe Api::ImagesController do
  render_views

  describe 'POST :upload_request' do
    let(:wall) { create(:wall) }
    let(:policy_generator) {
      class_double('AwsPolicyGenerator')
        .as_stubbed_const(transfer_nested_constants: true)
    }

    before do
      allow(policy_generator).to receive(:execute) { 'URL' }
    end

    before do
      post :upload_request, format: :json, wall_id: wall.access_code
    end

    context 'on success' do
      let(:request_result) { true }

      it 'responds with ok' do
        expect(response.status).to eq(200)
      end

      it 'returns an hash with an url and a request id' do
        expect(response.body).to eq({ upload_url: 'URL' }.to_json)
      end
    end
  end

  describe 'POST :photos' do
    let(:store_photo) {
      class_double("StorePhoto")
        .as_stubbed_const(transfer_nested_constants: true)
    }
    let(:wall) { create(:wall) }
    let(:action) { post :photos, { s3_url: 'URL', format: :json, wall_id: wall.access_code } }

    context 'on success' do
      before do
        allow(store_photo).to receive(:execute)
      end

      before do
        action
      end

      it 'notify all the other clients that I have uploaded a photo' do
        expect(store_photo).to have_received(:execute)
          .with('URL', session)
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
end

