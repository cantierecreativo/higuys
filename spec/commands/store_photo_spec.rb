require 'rails_helper'

describe StorePhoto do
  let(:guest) { create(:guest, :with_wall) }
  let(:s3_url) { 'http://higuysio.secchio/test.jpg' }
  let(:command) { described_class.new(s3_url, guest.id) }

  it "takes the s3_url" do
    expect(command.s3_url).to eq s3_url
  end

  it "takes the guest_id" do
    expect(command.guest_id).to eq guest.id
  end

  describe "#execute" do
    let(:result) { command.execute }
    let(:pusher) do
      class_double("Pusher").as_stubbed_const(
        transfer_nested_contants: true
      )
    end

    before do
      allow(pusher).to receive(:trigger)
    end

    context 'if the guest_id does not correspond to any existing guest' do
      let(:guest) { instance_double('Guest', id: 'foo') }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'if the guest has no associated walls' do
      let(:guest) { create(:guest) }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'if the url is not valid' do
      let(:s3_url) { 'http://foo.bar/' }

      before do
        stub_const 'ENV', {'S3_BUCKET_NAME' => 'higuysio'}
      end

      it 'returns false' do
        expect(result).to be false
      end
    end

    context "if the image already exists" do
      before do
        command.execute
      end

      it "returns false" do
        expect(result).to be false
      end

    end

    context 'when all data is ok' do
      it 'creates an image entry on the database' do
        expect { result }.to change { Image.count }.by(1)
      end

      it 'sets the last_image' do
        result
        expect(guest.reload.last_image).to_not be_nil
      end

      it 'pushes a "photo" event' do
        result
        expect(pusher).to have_received(:trigger).with("demo-#{guest.wall.access_code}", 'photo', guest_id: guest.id)
      end
    end
  end
end

