require 'rails_helper'

describe DeletePhoto do
  let(:filename) { '7ad2202e06c692b3da9c37096aaf531e.jpg' }
  let(:s3_url)   { "http://higuysio.s3.amazonaws.com/#{filename}" }
  let!(:image)  { create(:image, s3_url: s3_url) }
  let(:command) { described_class.new(image) }

  it "takes the s3_url" do
    expect(command.image).to eq image
  end

  describe "#execute" do
    let(:result) { command.execute }

    it "delete the image", :vcr do
      expect { result }.to change { Image.count }.from(1).to(0)
    end
  end

  describe "#filename" do
    it "returns the filename from s3 url" do
      expect(command.filename).to eq filename
    end
  end
end
