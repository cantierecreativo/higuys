class SessionManager < Struct.new(:session)
  def generate_and_sign_in_guest
    if current_user
      current_user
    else
      guest = Guest.create!(secret_token: secret_token)
      sign_in(guest)
      guest
    end
  end

  def generate_and_sign_in_registered_user(github_uid, email)
    user = if (( user = RegisteredUser.where(github_user_id: github_uid).first ))
      user
    elsif current_user.is_a?(Guest)
      current_user.update_attribute(:type, 'RegisteredUser')
      current_user.update_attribute(:github_user_id, github_uid)
      current_user.update_attribute(:email, email)
      current_user
    else
      user = RegisteredUser.create!(github_user_id: github_uid, email: email, secret_token: secret_token)
    end
    sign_in(user)
  end

  def current_user
    return nil unless session[:user_id]
    @user ||= User.where(id: session[:user_id]).first
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  private

  def secret_token
    SecureRandom.hex(32)
  end
end

