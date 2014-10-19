require 'rails_helper'

SessionManager
SetupWall
JoinWall
LeaveWall
Wall

RSpec.describe WallsController do
  let(:session_manager) { instance_double("SessionManager") }
  let(:user) { create(:guest) }

  before do
    allow(SessionManager).to receive(:new).with(session) { session_manager }
    allow(session_manager).to receive(:generate_and_sign_in_user) { user }
  end

  describe "POST create" do
    let(:setup_wall) {
      class_double("SetupWall")
        .as_stubbed_const(transfer_nested_constants: true)
    }
    let(:wall) { build(:wall, access_code: 'XXX') }
    context 'with no errors' do
      before do
        allow(setup_wall).to receive(:execute).with(user) { wall }
      end

      before { post :create }
      it { is_expected.to redirect_to wall_path('XXX') }
    end

    context 'with UserAlreadyHasAWall exception' do
      let(:another_wall) { create(:wall) }

      before do
        allow(setup_wall).to receive(:execute).with(user)
          .and_raise(UserAlreadyHasAWallException.new(another_wall))
      end

      before { post :create }
      it { is_expected.to redirect_to wall_path(another_wall) }
      it { is_expected.to set_the_flash[:alert] }
    end
  end

  describe "GET show" do
    let(:join_wall) {
      class_double("JoinWall")
        .as_stubbed_const(transfer_nested_constants: true)
    }
    let(:wall) { create(:wall) }

    context 'with no errors' do
      before do
        allow(join_wall).to receive(:execute).with(user, wall)
      end

      before { get :show, id: wall.access_code }

      it { is_expected.to respond_with 200 }
    end

    context 'with UserAlreadyHasAWall exception' do
      let(:another_wall) { create(:wall) }

      before do
        allow(join_wall).to receive(:execute).with(user, wall)
          .and_raise(UserAlreadyHasAWallException.new(another_wall))
      end

      before { get :show, id: wall.access_code }

      it { is_expected.to redirect_to wall_path(another_wall) }
      it { is_expected.to set_the_flash[:alert] }
    end

    context 'with TooManyUsersOnWallException' do
      before do
        allow(join_wall).to receive(:execute).with(user, wall)
          .and_raise(TooManyUsersOnWallException.new(wall))
      end

      before { get :show, id: wall.access_code }

      it { is_expected.to redirect_to root_path }
      it { is_expected.to set_the_flash[:alert] }
    end
  end

  describe 'POST leave' do
    let(:leave_wall) {
      class_double("LeaveWall")
        .as_stubbed_const(transfer_nested_constants: true)
    }
    let(:wall) { create(:wall) }

    context 'with no errors' do
      before do
        allow(leave_wall).to receive(:execute).with(user, wall)
      end

      before { post :leave, id: wall.access_code }

      it { is_expected.to redirect_to root_path }
      it { is_expected.to set_the_flash[:notice] }
    end
  end
end

