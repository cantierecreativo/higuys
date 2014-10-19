class Image < ActiveRecord::Base
  belongs_to :guest, inverse_of: :images
  validates :guest, presence: true
  validates :filename, presence: true, uniqueness: true

  scope :newst, -> { order(created_at: :desc) }

  def imgx_url
    imgx_uri = URI.parse(ENV['IMGX_URL'])
    imgx_uri.path = File.join(imgx_uri.path, filename)
    imgx_uri.to_s
  end
end
