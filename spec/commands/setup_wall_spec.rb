require 'rails_helper'

describe SetupWall do
  subject(:command) { SetupWall.new(session) }
  let(:session) { {} }

  it 'takes the session' do
    expect(command.session).to eq session
  end

  describe '#execute' do
    it 'returns a new wall' do
      result = command.execute

      expect(result).to be_a Wall
      expect(result).to be_persisted
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
        it 'makes the guest join the wall' do
          wall = command.execute
          expect(guest.reload.wall).to eq wall
        end
      end

      context 'if the guest is already linked with a wall' do
        let(:guest) { create(:guest, :with_wall) }

        it 'raises an exeception' do
          expect {
            command.execute
          }.to raise_error(SetupWall::GuestAlreadyHasAWall)
        end
      end
    end
  end
end

