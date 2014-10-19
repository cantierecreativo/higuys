require 'rails_helper'

PushEvent

describe JoinWall do
  subject(:command) { JoinWall.new(user, wall) }
  let(:wall) { create(:wall, access_code: 'XXX') }
  let(:user) { create(:guest) }

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
        @result = command.execute
      end

      it 'returns true' do
        expect(@result).to be_truthy
      end

      it 'makes the user join the wall' do
        expect(user.reload.wall).to eq wall
      end

      it 'pushes a "join" event' do
        expect(pusher).to have_received(:execute).with(
          wall,
          'join',
          user_id: user.id
        )
      end
    end

    context 'if the user is already linked with the wall' do
      let(:user) { create(:guest, wall: wall) }

      before do
        @result = command.execute
      end

      it 'returns true' do
        expect(@result).to be_falsy
      end
    end

    context 'if the user is already linked with another wall' do
      let(:user) { create(:guest, :with_wall) }

      it 'raises an exeception' do
        expect {
          command.execute
        }.to raise_error(UserAlreadyHasAWallException)
      end
    end

    context 'if the wall has reached the users number limit' do
      let!(:another_user) { create(:guest, wall: wall) }

      before do
        stub_const("JoinWall::MAX_USERS_FOR_WALL", 1)
      end

      it 'raises an exception' do
        expect {
          command.execute
        }.to raise_error(TooManyUsersOnWallException)
      end
    end
  end
end

