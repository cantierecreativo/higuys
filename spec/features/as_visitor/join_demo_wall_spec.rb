require 'rails_helper'

feature 'As visitor' do
  let(:home_page) { HomePage.new }
  let(:wall_page) { WallPage.new }

  scenario 'I want to create a demo wall', vcr: { match_requests_on: %i(method host path) } do
    home_page.load
    home_page.join_demo_wall!

    expect(wall_page).to have_wall
    expect(wall_page).to have_notice
  end

  context 'with an existing demo wall' do
    let(:wall) { create(:wall) }

    scenario 'I want to join it', vcr: { match_requests_on: %i(method host path) } do
      wall_page.load(id: wall.access_code)

      expect(wall_page).to have_wall
      expect(wall_page).to have_notice
    end
  end
end

