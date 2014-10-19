require 'rails_helper'

class RegisterAccountPage < Page
  set_url '/accounts/new'

  fields :name, :slug
  submit_button

  submission :register
end

feature 'As visitor' do
  let(:home_page) { HomePage.new }
  let(:register_account_page) { RegisterAccountPage.new }
  let(:wall_page) { WallPage.new }

  scenario 'I want to register my own account'  do
    home_page.load
    home_page.register_account!

    register_account_page.register!('Cantiere Creativo', 'cantiere')
    expect(wall_page).to have_notice

    expect(Account.first.wall).to be_present
  end
end

