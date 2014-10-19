class Wall < ActiveRecord::Base
  has_many :users,
    inverse_of: :wall,
    dependent: :destroy

  scope :inactive_since, -> (seconds) { joins(users: :last_image).where(["images.created_at < ?", seconds.ago]) }

  has_one :account,
    inverse_of: :wall

  def to_param
    access_code
  end
end

