require 'rails_helper'

class Homepage < Page
  set_url '/'
  set_url_matcher(/\//)
end

feature 'As visitor' do
  let(:homepage) { Homepage.new }

  scenario 'I want to access to the homepage' do
    homepage.load
    expect(homepage).to be_displayed
  end
end

