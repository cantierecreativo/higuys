require 'rails_helper'
require 'open-uri'

describe AwsPolicyGenerator do
  let(:command) { described_class.new }
  let(:upload_url) { "UPLOAD_URL_S3" }

  describe "#execute" do
    let(:result) { command.execute }
    let(:filename) { "FILENAME" }
    let(:bucket_name) { ENV["S3_BUCKET_NAME"] }
    let(:expected_url) { "http://#{bucket_name}.s3.amazonaws.com/#{filename}" }

    before do
      allow(command).to receive(:filename).and_return(filename)
    end

    it "returns the upload URI for s3" do
      expect(result.start_with?(expected_url)).to be true
    end
  end
end
