require 'rails_helper'

feature 'As user in an account' do
  let(:sign_in_page) { SigninPage.new }
  let(:account_page) { AccountPage.new }
  let(:home_page) { HomePage.new }
  let(:user) { create(:registered_user, :with_account) }

  before do
    sign_in_page.load(user_id: user.id)
  end

  before do
    account_page.load(account_id: user.wall.account.slug)
  end

  scenario 'I want to leave it', vcr: { match_requests_on: %i(method host path) }  do
    account_page.leave!
    expect(home_page).to have_notice
  end

  let(:wall_page) { WallPage.new }
  let(:another_wall) { create(:wall) }

  scenario 'I cannot join another one', vcr: { match_requests_on: %i(method host path) } do
    wall_page.load(id: another_wall.access_code)
    expect(home_page).to have_alert
  end
end

