class SessionManager < Struct.new(:session)
  def generate_and_sign_in_guest
    if current_guest
      current_guest
    else
      guest = Guest.create!
      sign_in(guest)
      guest
    end
  end

  def sign_in(guest)
    session[:guest_id] = guest.id
  end

  def current_guest
    return nil unless session[:guest_id]
    @guest ||= Guest.where(id: session[:guest_id]).first
  end
end

