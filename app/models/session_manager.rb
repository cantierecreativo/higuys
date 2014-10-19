class SessionManager < Struct.new(:session)
  def generate_and_sign_in_guest
    if current_user
      current_user
    else
      guest = Guest.create!
      sign_in(guest)
      guest
    end
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    return nil unless session[:user_id]
    @user ||= User.where(id: session[:user_id]).first
  end
end

