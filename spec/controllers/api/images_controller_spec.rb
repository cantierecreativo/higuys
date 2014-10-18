require 'rails_helper'

AwsPolicyGenerator

describe Api::ImagesController do
  describe 'POST :upload_request' do
    let(:url) { 'URL' }
    let(:upload_request) {
      class_double('AwsPolicyGenerator')
        .as_stubbed_const(transfer_nested_constants: true)
    }
    let(:action) { post :upload_request }

    before do
      allow(upload_request).to receive(:execute) { double(url: url, upload_url: url) }
    end

    before do
      action
    end

    context 'on success' do
      let(:request_result) { true }

      it 'responds with ok' do
        expect(response.status).to eq(200)
      end

      it 'returns an hash with an url and a request id' do
        expect(response.body).to eq({ upload_url: url, url: url }.to_json)
      end
    end
  end

  describe 'POST :photos' do
    let(:store_photo)  { instance_double('StorePhoto', execute: true) }
    let(:s3_url) { 'bucket_url' }
    let(:guest_id) { 'GUEST_ID' }
    let(:params) { { s3_url: s3_url } }
    let(:session) { { guest_id: guest_id } }
    let(:action) { post :photos, params, session }
    let(:execute_status) { true }

    before do
      allow(StorePhoto).to receive(:new).with(s3_url, guest_id).and_return(store_photo)
      allow(store_photo).to receive(:execute).and_return(execute_status)
    end

    before do
      action
    end

    context 'on success' do
      let(:execute_status) { true }

      it 'notify all the other clients that I have uploaded a photo' do
        expect(store_photo).to have_received(:execute)
      end

      it 'responds with ok' do
        expect(response.status).to eq(200)
      end
    end

    context 'on error' do
      let(:execute_status) { false }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end
    end
  end
end
