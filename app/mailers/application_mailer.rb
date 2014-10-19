class ApplicationMailer < ActionMailer::Base
  default from: "do-not-reply@higuys.io"

  def invitation(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: '[hi guys!] Someone invited you to join his wall')
  end
end

