require 'rails_helper'

describe ApplicationMailer, type: :mailer do
  describe 'invitation' do
    let(:invitation) { create(:invitation) }

    it 'renders' do
      ApplicationMailer.invitation(invitation)
    end
  end
end

