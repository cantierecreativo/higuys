require 'rails_helper'

class HomePage < Page
  set_url '/'

  action :join_demo_wall
end

class WallPage < Page
  set_url '/demo{/id}'
  element :wall, '.wall'
end

feature 'As visitor' do
  let(:home_page) { HomePage.new }
  let(:wall_page) { WallPage.new }

  scenario 'I want to join a demo wall', vcr: { match_requests_on: %i(method host path) } do
    home_page.load
    home_page.join_demo_wall_element.click

    expect(wall_page).to have_wall
  end
end

