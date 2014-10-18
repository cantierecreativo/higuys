class Guest < ActiveRecord::Base
  has_many :images, dependent: :destroy, inverse_of: :guest
  belongs_to :last_image,
    class_name: 'Image'

  belongs_to :wall,
    inverse_of: :guests

  scope :by_id, -> { order(id: :asc) }

  def to_json
    data = { id: id, image_url: nil }
    data[:image_url] = last_image.imgx_url if last_image.present?
    data
  end
end
