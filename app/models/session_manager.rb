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

  def generate_and_sign_in_registered_user(github_uid)
    user = if current_user.is_a?(Guest)
      current_user.update_attribute(type: 'RegisteredUser')
      current_user.update_attribute(github_user_id: github_uid)
      current_user
    elsif (( user = RegisteredUser.where(github_user_id: github_uid).first ))
      user
    else
      user = RegisteredUser.create!(github_user_id: github_uid)
    end
    sign_in(user)
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def current_user
    return nil unless session[:user_id]
    @user ||= User.where(id: session[:user_id]).first
  end
end

