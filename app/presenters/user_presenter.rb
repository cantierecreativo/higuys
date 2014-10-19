class UserPresenter < BasePresenter
  def display_name
    if object.is_a? Guest
      "Guest user"
    else
      email
    end
  end
end

