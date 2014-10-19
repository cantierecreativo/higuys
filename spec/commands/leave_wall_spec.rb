require 'rails_helper'

PushEvent

describe LeaveWall do
  subject(:command) { LeaveWall.new(user, wall) }
  let(:wall) { create(:wall, access_code: 'XXX') }
  let(:user) { create(:guest, wall: wall) }

  it 'takes the user' do
    expect(command.user).to eq user
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

    context 'if the user is not linked with a wall' do
      before do
        command.execute
      end

      it 'makes the user leave the wall' do
        expect(user.reload.wall).to be_nil
      end

      it 'pushes a "leave" event' do
        expect(pusher).to have_received(:execute).with(
          wall,
          'leave',
          user_id: user.id
        )
      end
    end
  end
end

