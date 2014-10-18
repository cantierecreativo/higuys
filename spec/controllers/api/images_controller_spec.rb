require 'rails_helper'

describe Api::ImagesController do
  describe 'POST :upload_request' do
    let(:url) { 'URL' }
    let(:request_id) { 'REQUEST_ID' }
    let(:request_result) { true }
    let(:upload_request) { double('UploadRequest', url: url, request_id: request_id, execute: request_result) }
    let(:params) { { } }
    let(:action) { post :upload_request, params }

    before do
      allow(Api::UploadRequest).to receive(:new).and_return(upload_request)
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
        expect(response.body).to eq({ success: true, url: url }.to_json)
      end
    end

    context 'on error' do
      let(:request_result) { false }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end

      it 'returns an hash with the status of the operation' do
        expect(response.body).to eq({ success: false }.to_json)
      end
    end
  end

  describe 'POST :photos' do
    let(:notifier_result) { true }
    let(:upload_notifier)  { double('UploadNotifier', execute: notifier_result) }
    let(:s3_url) { 'bucket_url' }
    let(:params) { { s3_url: s3_url } }
    let(:action) { post :photos, params }

    before do
      allow(Api::UploadNotifier).to receive(:new).with(s3_url).and_return(upload_notifier)
    end

    before do
      action
    end

    context 'on success' do
      let(:notifier_result) { true }

      it 'notify all the other clients that I have uploaded a photo' do
        expect(upload_notifier).to have_received(:execute)
      end

      it 'responds with ok' do
        expect(response.status).to eq(200)
      end

      it 'returns an hash with the status of the operation' do
        expect(response.body).to eq({ success: true }.to_json)
      end
    end

    context 'on error' do
      let(:notifier_result) { false }

      it 'responds with unprocessable entity' do
        expect(response.status).to eq(422)
      end

      it 'returns an hash with the status of the operation' do
        expect(response.body).to eq({ success: false }.to_json)
      end
    end
  end
end

