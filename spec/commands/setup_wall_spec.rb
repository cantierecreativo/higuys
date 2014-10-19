require 'rails_helper'

describe SetupWall do
  subject(:command) { SetupWall.new(guest) }
  let(:guest) { create(:guest) }

  it 'takes the guest' do
    expect(command.guest).to eq guest
  end

  describe '#execute' do
    it 'returns a new wall' do
      result = command.execute

      expect(result).to be_a Wall
      expect(result).to be_persisted
    end

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
        }.to raise_error(GuestAlreadyHasAWallException)
      end
    end
  end
end

