class Guest < ActiveRecord::Base
  has_many :images, dependent: :destroy, inverse_of: :guest

  belongs_to :wall,
    inverse_of: :guests
end

