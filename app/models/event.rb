class Event < ApplicationRecord
  extend Enumerize
  enumerize :category, in: %i[music sports business hobby other], scope: true, predicates: true
  attribute :category, :string, default: :other

  belongs_to :user

  validates :title, presence: true
  validates :place, presence: true
  validates_datetime :start_at, on_or_after: -> { Time.current }
  validates_datetime :end_at, after: :start_at, on_or_after: -> { Time.current }
  validates :category, presence: true
end
