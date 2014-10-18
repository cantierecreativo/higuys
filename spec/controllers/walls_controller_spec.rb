require 'rails_helper'

SetupWall
Wall

RSpec.describe WallsController do

  describe "POST create" do
    let(:setup_wall) { class_double("SetupWall").as_stubbed_const }
    let(:wall) { build(:wall, access_code: 'XXX') }

    before do
      allow(setup_wall).to receive(:execute).with(session) { wall }
    end

    it "returns http success" do
      post :create
      expect(response).to redirect_to(wall_path('XXX'))
    end
  end

  describe "GET show" do
    it "returns http success" do
      get :show, id: 'XXX'
      expect(response).to be_success
    end
  end

end

