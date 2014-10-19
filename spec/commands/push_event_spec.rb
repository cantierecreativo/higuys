require 'rails_helper'

describe PushEvent do
  subject(:command) { PushEvent.new(wall, event, data) }
  let(:wall) { create(:wall, access_code: 'XXX') }
  let(:event) { 'foobar' }
  let(:data) { 'data' }

  let(:pusher) do
    class_double("Pusher").as_stubbed_const(
      transfer_nested_contants: true
    )
  end

  describe '#execute' do
    before do
      allow(pusher).to receive(:trigger)
    end

    before do
      command.execute
    end

    it 'propagates the message to the wall channel' do
      expect(pusher).to have_received(:trigger)
        .with('demo-XXX', event, data)
    end
  end
end

