require 'rails_helper'

describe SetupWall do
  subject(:command) { SetupWall.new(session) }
  let(:session) { {} }

  it 'takes the session' do
    expect(command.session).to eq session
  end

  describe '#execute' do
    let(:wall_class) {  }
    let(:result) { command.execute }

    it 'returns a new wall' do
      expect(result).to be_a Wall
    end
  end
end

