class User < ActiveRecord::Base
  has_many :images, dependent: :destroy, inverse_of: :user

  belongs_to :last_image,
    class_name: 'Image'

  belongs_to :wall,
    inverse_of: :users

  scope :active_in_the_last, -> (seconds) {
    joins(:last_image).where(images: { created_at: (seconds.ago..Time.now) })
  }

  scope :by_id, -> { order(id: :asc) }
end

