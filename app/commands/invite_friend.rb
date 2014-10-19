class InviteFriend < Struct.new(:account, :params)
  extend Command

  def execute
    invitation.tap do |invitation|
      send_invitation if invitation.save
    end
  end

  private

  def send_invitation
  end

  def invitation
    @invitation ||= Invitation.new(
      account: account,
      email: params[:email],
      invitation_code: SecureRandom.hex(10)
    )
  end
end

