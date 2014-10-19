require 'rails_helper'

describe SessionManager do
  let(:session_manager) { described_class.new(session) }
  let(:session) { {} }
  
  describe "#current_user" do

    context "when no user exists in session" do
      it "returns nil" do
        expect(session_manager.current_user).to be_nil
      end
    end

    context "with a non existing id" do
      let(:session) { { user_id: 'an_user_idx' } }

      it "returns nil" do
        expect(session_manager.current_user).to be_nil
      end
    end

    context "with a valid user" do
      let(:session) { { user_id: user.id } }
      let(:user) { create(:guest) }

      it "returns the current user" do
        expect(session_manager.current_user).to eq user
      end
    end
  end

  describe "generate_and_sign_in_guest" do
    let(:result) { session_manager.generate_and_sign_in_guest }
    let(:current_user) { create(:guest) }
    let(:secret_token) { "a_secret_token" }
    let(:user) { 'an_user' }

    before do
      allow(session_manager).to receive(:current_user).and_return(current_user)
      allow(session_manager).to receive(:sign_in)
      allow(session_manager).to receive(:secret_token).and_return(secret_token)
      allow(Guest).to receive(:create!).and_return(user)
    end


    before do
      result
    end

    context "when already exists a current user" do
      it "returns the current user" do
        expect(result).to eq current_user
      end

      it "doesn't sign in again" do
        expect(session_manager).to_not have_received(:sign_in)
      end
    end

    context "else" do
      let(:current_user) { nil }

      it "create a new guest user" do
        expect(Guest).to have_received(:create!)
      end

      it "sign the user" do
        expect(session_manager).to have_received(:sign_in).with(user)
      end
    end
  end
end
