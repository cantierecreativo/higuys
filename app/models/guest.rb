class Guest < ActiveRecord::Base
  has_many :images, dependent: :destroy, inverse_of: :guest
  belongs_to :last_image,
    class_name: 'Image'

  belongs_to :wall,
    inverse_of: :guests

  scope :active, -> { joins(:last_image).where(images: { created_at: (5.minutes.ago..Time.now) }) }
  scope :by_id, -> { order(id: :asc) }
end
