require 'rails_helper'

feature 'As visitor in a wall' do
  let(:wall_page) { WallPage.new }
  let(:home_page) { HomePage.new }
  let(:wall) { create(:wall) }

  before do
    wall_page.load(id: wall.access_code)
  end

  scenario 'I want to leave it', vcr: { match_requests_on: %i(method host path) }  do
    wall_page.leave!
    expect(home_page).to have_notice
  end
end

