require 'rails_helper'

class RegisterAccountPage < Page
  set_url '/accounts/new'

  fields :name, :slug
  submit_button

  submission :register
end

feature 'As user' do
  let(:home_page) { HomePage.new }
  let(:register_account_page) { RegisterAccountPage.new }
  let(:wall_page) { WallPage.new }
  let(:sign_in_page) { SigninPage.new }
  let(:user) { create(:registered_user) }

  before do
    sign_in_page.load(user_id: user.id)
  end

  scenario 'I want to register my own account'  do
    home_page.register_account!

    register_account_page.register!('Cantiere Creativo', 'cantiere')
    expect(wall_page).to have_notice

    expect(Account.first.wall).to be_present
  end
end

