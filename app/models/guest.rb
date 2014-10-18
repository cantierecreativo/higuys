class Guest < ActiveRecord::Base
  has_many :images, dependent: :destroy, inverse_of: :guest
  belongs_to :last_image,
    class_name: 'Image'

  belongs_to :wall,
    inverse_of: :guests

  scope :by_id, -> { order(id: :asc) }
end
