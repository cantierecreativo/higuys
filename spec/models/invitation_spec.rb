require 'rails_helper'

RSpec.describe Invitation, type: :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :invitation_code }
  it { is_expected.to validate_presence_of :account }

  it {
    create(:invitation)
    is_expected.to validate_uniqueness_of :invitation_code
  }

  it {
    create(:invitation)
    is_expected.to validate_uniqueness_of(:email).scoped_to(:account_id)
  }

  it 'validates correct email' do
    expect(build(:invitation, email: 'foo')).to be_invalid
  end
end

