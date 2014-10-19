require 'rails_helper'

feature 'As visitor in a wall' do
  let(:wall_page) { WallPage.new }
  let(:home_page) { HomePage.new }
  let(:wall) { create(:wall) }
  let(:another_wall) { create(:wall) }

  before do
    wall_page.load(id: wall.access_code)
  end

  scenario 'I want to leave it', vcr: { match_requests_on: %i(method host path) } do
    wall_page.leave!
    expect(home_page).to have_notice
  end

  scenario 'I cannot join another one', vcr: { match_requests_on: %i(method host path) } do
    wall_page.load(id: another_wall.access_code)
    expect(home_page).to have_alert
  end
end

