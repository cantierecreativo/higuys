require 'rails_helper'

RSpec.describe Image, type: :model do

  let(:url)   { "http://higuysio.secchio" }
  let(:image) { build(:image, s3_url: url) }

  it { should validate_presence_of :guest }
  it { should validate_presence_of :s3_url }

  describe "with a valid s3 url" do
    it "validated the s3_url" do
      expect(image).to be_valid
    end
  end

  describe "with an invalid s3 url" do
    let(:url) { "http://otherbucket.secchio" }

    it "doesn't validate the s3_url" do
      expect(image).not_to be_valid
    end
  end

  describe '#imgx_url' do
    let(:image) { create(:image, s3_url: 'http://higuysio.secchio/test.jpg') }

    before do
      stub_const 'ENV', { 'IMGX_URL' => 'http://foobar.imgx.com/' }
    end

    it 'returns the imgx_url of the image' do
      expect(image.imgx_url).to eq('http://foobar.imgx.com/test.jpg')
    end
  end
end
