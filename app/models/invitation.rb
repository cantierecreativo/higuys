class Invitation < ActiveRecord::Base
  belongs_to :account,
    inverse_of: :invitations

  validates :email, email: true, presence: true
  validates :invitation_code, presence: true
  validates :account, presence: true

  validates :email, uniqueness: { scope: :account_id }
  validates :invitation_code, uniqueness: true
end

