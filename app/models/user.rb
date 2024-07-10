class User < ApplicationRecord
  AVATAR_CONTENT_TYPE = %w[image/png image/jpg image/jpeg image/gif].freeze

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :validatable

  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_limit: [50, 50]
  end

  has_many :events, dependent: :destroy
  has_many :participations, dependent: :destroy
  has_many :participate_events, -> { published }, through: :participations, source: :event
  has_many :favorites, dependent: :destroy
  has_many :favorite_events, -> { published.order('favorites.created_at DESC') }, through: :favorites, source: :event

  validates :name, presence: true
  validates :avatar, content_type: { in: AVATAR_CONTENT_TYPE }, size: { less_than: 5.megabytes }

  scope :default_order, -> { order(name: :asc, id: :desc) }

  def participate?(event)
    participations.exists?(event:)
  end

  def favorite?(event)
    favorites.exists?(event:)
  end
end
