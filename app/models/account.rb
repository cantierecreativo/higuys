class Account < ActiveRecord::Base
  belongs_to :wall, inverse_of: :account, dependent: :destroy

  has_many :invitations,
    inverse_of: :account,
    dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
  validates :wall, presence: true

  validate :check_slug

  def to_param
    slug
  end

  private

  def check_slug
    if slug && slug.parameterize != slug
      errors.add(:slug, :invalid)
    end
  end
end

