require 'rails_helper'

describe SetupWall do
  subject(:command) { SetupWall.new(user) }
  let(:user) { create(:guest) }

  it 'takes the user' do
    expect(command.user).to eq user
  end

  describe '#execute' do
    it 'returns a new wall' do
      result = command.execute

      expect(result).to be_a Wall
      expect(result).to be_persisted
    end

    context 'if the user is not linked with a wall' do
      it 'makes the user join the wall' do
        wall = command.execute
        expect(user.reload.wall).to eq wall
      end
    end

    context 'if the user is already linked with a wall' do
      let(:user) { create(:guest, :with_wall) }

      it 'raises an exeception' do
        expect {
          command.execute
        }.to raise_error(UserAlreadyHasAWallException)
      end
    end
  end
end

