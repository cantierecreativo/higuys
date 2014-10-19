require 'rails_helper'

class AcceptInvitationPage < Page
  set_url '/accounts{/account_id}/invitations/accept{?invitation_code}'
end

feature 'As a user who received an invitation' do
  let(:sign_in_page) { SigninPage.new }
  let(:invitation) { create(:invitation) }
  let(:accept_invitation_page) { AcceptInvitationPage.new }
  let(:user) { create(:registered_user) }
  let(:wall_page) { WallPage.new }

  before do
    sign_in_page.load(user_id: user.id)
  end

  scenario 'I want to accept the invitation', vcr: { match_requests_on: %i(method host path) }  do
    accept_invitation_page.load(
      account_id: invitation.account.slug,
      invitation_code: invitation.invitation_code
    )
    expect(wall_page).to have_notice
    expect(wall_page).to have_wall
  end
end

