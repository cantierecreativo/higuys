require 'rails_helper'

class InvitationsPage < Page
  set_url '/accounts{/account_id}/invitations'
end

feature 'As user within an account' do
  let(:sign_in_page) { SigninPage.new }
  let(:invitations_page) { InvitationsPage.new }
  let(:user) { create(:registered_user, :with_account) }

  before do
    sign_in_page.load(user_id: user.id)
  end

  scenario 'I want to invite a friend to my wall' do
    invitations_page.load(account_id: user.wall.account.id)
    save_and_open_page
  end
end

