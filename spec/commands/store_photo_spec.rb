require 'rails_helper'

PushEvent
Guest

describe StorePhoto do
  let(:guest) { create(:guest, :with_wall) }
  let(:filename) { 'test.jpg' }
  let(:s3_url) { "http://higuysio.secchio/#{filename}" }
  let(:command) { described_class.new(s3_url, session) }
  let(:session) { { guest_id: guest.id } }

  it "takes the s3_url" do
    expect(command.s3_url).to eq s3_url
  end

  it "takes the session" do
    expect(command.session).to eq session
  end

  describe "#filename" do
    it "returns the filename extracted from url" do
      expect(command.filename).to eq filename
    end
  end

  describe "#execute" do
    let(:pusher) do
      class_double("PushEvent").as_stubbed_const
    end

    before do
      allow(pusher).to receive(:execute)
    end

    context 'if the guest_id does not correspond to any existing guest' do
      let(:guest) { instance_double('Guest', id: 'foo') }

      it 'raises InvalidInputException' do
        expect { command.execute }.to raise_error StorePhoto::InvalidInputException
      end
    end

    context 'if the guest has no associated walls' do
      let(:guest) { create(:guest) }

      it 'raises InvalidInputException' do
        expect { command.execute }.to raise_error StorePhoto::InvalidInputException
      end
    end

    context 'if the url is not valid' do
      let(:s3_url) { 'http://foo.bar/' }

      before do
        stub_const 'ENV', {'S3_BUCKET_NAME' => 'higuysio'}
      end

      it 'raises InvalidInputException' do
        expect { command.execute }.to raise_error StorePhoto::InvalidInputException
      end
    end

    context "if they image already exists" do
      let!(:image) { create(:image, filename: filename) }

      it 'raises InvalidInputException' do
        expect { command.execute }.to raise_error StorePhoto::InvalidInputException
      end
    end

    context 'when all data is ok' do
      before do
        @result = command.execute
      end


      it 'creates an image entry on the database' do
        expect(@result).to be_a Image
        expect(@result).to be_persisted
      end

      it 'sets the last_image' do
        expect(guest.reload.last_image).to_not be_nil
      end

      it 'pushes a "photo" event' do
        expect(pusher).to have_received(:execute)
          .with(guest.wall, 'photo', guest_id: guest.id)
      end
    end
  end
end
