require 'rails_helper'

describe AwsDeletePhoto do
  let(:image_path) { 'production/demo-4d9219a8d1df4743/ca98fab4b4a6d9da960c4388bfe1f18d.jpg' }
  let(:command) { described_class.new(image_path) }

  it "takes the s3_url" do
    expect(command.image_path).to eq image_path
  end
end
