require 'rails_helper'

PushEvent

describe LeaveWall do
  subject(:command) { LeaveWall.new(guest, wall) }
  let(:wall) { create(:wall, access_code: 'XXX') }
  let(:guest) { create(:guest, wall: wall) }

  it 'takes the guest' do
    expect(command.guest).to eq guest
  end

  it 'takes the wall' do
    expect(command.wall).to eq wall
  end

  describe '#execute' do
    let(:pusher) {
      class_double("PushEvent").as_stubbed_const
    }

    before do
      allow(pusher).to receive(:execute)
    end

    context 'if the guest is not linked with a wall' do
      before do
        command.execute
      end

      it 'makes the guest leave the wall' do
        expect(guest.reload.wall).to be_nil
      end

      it 'pushes a "leave" event' do
        expect(pusher).to have_received(:execute).with(
          wall,
          'leave',
          guest_id: guest.id
        )
      end
    end
  end
end

