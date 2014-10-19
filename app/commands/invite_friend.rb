class InviteFriend < Struct.new(:account, :params)
  extend Command

  def execute
  end

  private

  def invitation
    @invitation ||= Invitation.new(
      account: account,
      invitation_code: SecureRandom.hex(10)
    )
  end
end

