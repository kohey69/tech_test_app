class Review < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :user_id, uniqueness: { scope: :event }

  scope :default_order, -> { order(created_at: :desc, id: :desc) }
end
