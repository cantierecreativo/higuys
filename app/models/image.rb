class Image < ActiveRecord::Base
  belongs_to :guest, inverse_of: :images
  validates :guest, presence: true
  validates :s3_url, presence: true, uniqueness: true

  validate :ensure_valid_s3_url

  private

  def ensure_valid_s3_url
    return if s3_url.blank?
    unless self.s3_url.start_with?("http://#{ENV["S3_BUCKET_NAME"]}")
      errors.add(:s3_url, "It's not our bucket")
    end
  end
end
