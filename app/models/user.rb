class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :validatable

  has_one_attached :avatar do |attachable|
    attachable.variant :small, resize_to_limit: [50, 50]
  end

  validates :name, presence: true
end
