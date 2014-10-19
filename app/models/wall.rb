class Wall < ActiveRecord::Base
  has_many :guests,
    inverse_of: :wall,
    dependent: :destroy

  scope :inactive_since, -> (seconds) { joins(guests: :last_image).where(["images.created_at < ?", seconds.ago]) }

  has_one :account,
    inverse_of: :wall

  def to_param
    access_code
  end
end

