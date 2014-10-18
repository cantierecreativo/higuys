require 'rails_helper'

describe JoinWall do
  subject(:command) { JoinWall.new(wall, session) }
  let(:session) { {} }
  let(:wall) { create(:wall) }

  it 'takes the session' do
    expect(command.session).to eq session
  end

  it 'takes the wall' do
    expect(command.wall).to eq wall
  end

  describe '#execute' do
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
          command.execute
        end

        it 'makes the guest join the wall' do
          expect(guest.reload.wall).to eq wall
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
    end
  end
end

