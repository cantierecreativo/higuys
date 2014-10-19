require 'rails_helper'

class RegisterAccountPage < Page
  set_url '/accounts/new'

  fields :name, :slug
  submit_button

  submission :register
end

class SigninPage < Page
  set_url '/auth/force{/user_id}'
end

feature 'As visitor' do
  let(:home_page) { HomePage.new }
  let(:register_account_page) { RegisterAccountPage.new }
  let(:wall_page) { WallPage.new }
  let(:sign_in_page) { SigninPage.new }
  let(:user) { create(:registered_user) }

  scenario 'I want to register my own account'  do
    sign_in_page.load(user_id: user.id)

    home_page.register_account!

    register_account_page.register!('Cantiere Creativo', 'cantiere')
    expect(wall_page).to have_notice

    expect(Account.first.wall).to be_present
  end
end

