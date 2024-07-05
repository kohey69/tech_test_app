class User < ApplicationRecord
  AVATAR_CONTENT_TYPE = %w[image/png image/jpg image/jpeg image/gif].freeze

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :validatable

  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_limit: [50, 50]
  end

  validates :name, presence: true
  validates :avatar, content_type: { in: AVATAR_CONTENT_TYPE }, size: { less_than: 5.megabytes }
end
