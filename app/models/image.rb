class Image < ActiveRecord::Base
  belongs_to :guest, inverse_of: :images
  validates :guest, presence: true
  validates :image_path, presence: true, uniqueness: true

  scope :newst, -> { order(created_at: :desc) }

  def imgx_url
    imgx_uri = URI.parse(ENV.fetch('IMGX_URL'))
    imgx_uri.path = File.join(imgx_uri.path, image_path)
    imgx_uri.to_s
  end
end
