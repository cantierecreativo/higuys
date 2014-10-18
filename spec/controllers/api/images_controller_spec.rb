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
      allow(upload_request).to receive(:execute) { url }
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
        expect(response.body).to eq({ url: url }.to_json)
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

