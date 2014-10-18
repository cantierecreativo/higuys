require 'rails_helper'

describe LeaveWall do
  subject(:command) { LeaveWall.new(wall, session) }
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

    context 'if the session has a guest user within the wall' do
      let(:guest) { create(:guest, wall: wall) }
      let(:session) { { guest_id: guest.id } }

      context 'if the guest is not linked with a wall' do
        before do
          command.execute
        end

        it 'makes the guest leave the wall' do
          expect(guest.reload.wall).to be_nil
        end

        it 'pushes a "leave" event' do
          expect(pusher).to have_received(:trigger).with(
            'demo-XXX',
            'leave',
            guest_id: guest.id
          )
        end
      end
    end
  end
end

