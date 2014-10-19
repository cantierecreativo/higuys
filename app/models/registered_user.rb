class RegisteredUser < User
  validates :github_user_id, presence: true
  validates :github_user_id, uniqueness: true
  validates :email, email: true, presence: true
end

