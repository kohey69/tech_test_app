class Event < ApplicationRecord
  extend Enumerize
  enumerize :category, in: %i[music sports business hobby other], scope: true, predicates: true
  attribute :category, :string, default: :other

  belongs_to :user
  has_many :participations, dependent: :destroy
  has_many :participate_users, through: :participations, source: :user

  validates :title, presence: true
  validates :place, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates_datetime :start_at, on_or_after: -> { Time.current }, on: :create
  validates_datetime :end_at, after: :start_at
  validates :category, presence: true

  scope :default_order, -> { order(start_at: :desc, id: :desc) }
  scope :published, -> { where(published: true) }
  scope :not_started, -> { where('start_at > ?', Time.current) }
end
