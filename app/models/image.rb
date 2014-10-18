class Image < ActiveRecord::Base
  belongs_to :guest, inverse_of: :images
  validates :guest, presence: true
  validates :s3_url, presence: true, uniqueness: true

  validate :ensure_valid_s3_url

  scope :newst, -> { order(created_at: :desc) }

  def imgx_url
    if s3_url.present?
      filename = File.basename(URI.parse(s3_url).path)
      imgx_uri = URI.parse(ENV['IMGX_URL'])
      imgx_uri.path = File.join(imgx_uri.path, filename)
      imgx_uri.to_s
    end
  end

  private

  def ensure_valid_s3_url
    return if s3_url.blank?
    unless self.s3_url.start_with?("http://#{ENV["S3_BUCKET_NAME"]}")
      errors.add(:s3_url, "It's not our bucket")
    end
  end
end
