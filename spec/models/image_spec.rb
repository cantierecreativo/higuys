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
end
