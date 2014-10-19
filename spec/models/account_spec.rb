require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :slug }
  it { should validate_presence_of :wall }
  it {
    create(:account)
    should validate_uniqueness_of :slug
  }

  it 'requires a parameterized slug' do
    account = build(:account, slug: 'ù')
    expect(account).not_to be_valid
  end
end

