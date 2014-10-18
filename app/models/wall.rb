class Wall < ActiveRecord::Base
  has_many :guests,
    inverse_of: :wall,
    dependent: :destroy

  def to_param
    access_code
  end
end
