require 'rails_helper'
require 'open-uri'

describe AwsPolicyGenerator do
  let(:command) { described_class.new(image_path) }
  let(:image_path) { 'foo/bar.png' }

  describe "#execute" do
    let(:result) { command.execute }
    let(:bucket_name) { ENV.fetch("S3_BUCKET_NAME") }

    it "returns the upload URI for s3" do
      build(:image)
      url = "http://#{bucket_name}.s3.amazonaws.com/#{image_path}"
      expect(result.start_with?(url)).to be true
    end
  end
end

