require 'rails_helper'

RSpec.describe Image, type: :model do
  let(:image_path) { "foo/bar/image.jpg" }
  let(:image) { build(:image, image_path: image_path) }

  it { should validate_presence_of :guest }
  it { should validate_presence_of :image_path }

  describe '#imgx_url' do
    let(:image) { create(:image, image_path: 'test.jpg') }

    before do
      stub_const 'ENV', { 'IMGX_URL' => 'http://foobar.imgx.com/' }
    end

    it 'returns the imgx_url of the image' do
      expect(image.imgx_url).to eq('http://foobar.imgx.com/test.jpg')
    end
  end
end

