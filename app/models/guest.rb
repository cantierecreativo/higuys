class Guest < ActiveRecord::Base
  belongs_to :wall,
    inverse_of: :guests
end

