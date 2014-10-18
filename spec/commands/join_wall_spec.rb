require 'rails_helper'

describe JoinWall do
  subject(:command) { JoinWall.new(wall, session) }
  let(:session) { {} }
  let(:wall) { create(:wall, access_code: 'XXX') }

  it 'takes the session' do
    expect(command.session).to eq session
  end

  it 'takes the wall' do
    expect(command.wall).to eq wall
  end

  describe '#execute' do
    let(:pusher) {
      class_double("Pusher").as_stubbed_const(
        transfer_nested_constants: true
      )
    }

    before do
      allow(pusher).to receive(:trigger)
    end

    context 'if the session has no guest user' do
      before do
        command.execute
      end

      it 'generates a user and stores it in the session' do
        expect(Guest.find(session[:guest_id])).to be_present
      end
    end

    context 'if the session has a guest user' do
      let(:guest) { create(:guest) }
      let(:session) { { guest_id: guest.id } }

      context 'if the guest is not linked with a wall' do
        before do
          @result = command.execute
        end

        it 'returns true' do
          expect(@result).to be_truthy
        end

        it 'makes the guest join the wall' do
          expect(guest.reload.wall).to eq wall
        end

        it 'pushes a "join" event' do
          expect(pusher).to have_received(:trigger).with(
            'demo-XXX',
            'join',
            guest_id: guest.id
          )
        end
      end

      context 'if the guest is already linked with a wall' do
        let(:guest) { create(:guest, wall: wall) }

        before do
          @result = command.execute
        end

        it 'returns true' do
          expect(@result).to be_falsy
        end
      end

      context 'if the guest is already linked with another wall' do
        let(:guest) { create(:guest, :with_wall) }

        it 'raises an exeception' do
          expect {
            command.execute
          }.to raise_error(GuestAlreadyHasAWallException)
        end
      end

      context 'if the wall has reached the guests number limit' do
        let!(:another_guest) { create(:guest, wall: wall) }

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
end
