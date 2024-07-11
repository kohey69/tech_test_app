class Event < ApplicationRecord
  extend Enumerize
  enumerize :category, in: %i[music sports business hobby other], predicates: true
  attribute :category, :string, default: :other

  belongs_to :user
  has_many :participations, dependent: :destroy
  has_many :participate_users, through: :participations, source: :user
  has_many :favorites, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, presence: true
  validates :place, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates_datetime :start_at, on_or_after: -> { Time.current }, on: :create
  validates_datetime :end_at, after: :start_at
  validates :category, presence: true

  scope :default_order, -> { order(start_at: :desc, id: :desc) }
  scope :published, -> { where(published: true) }
  scope :ended, -> { where('end_at <= ?', Time.current) }
  scope :not_ended, -> { where('end_at > ?', Time.current) }
  scope :order_by_start_at, -> { order(start_at: :asc, id: :asc) }
  scope :order_by_participations_count, -> { joins(:participations).group('events.id').order('COUNT(participations.id) DESC, events.start_at ASC') }
  scope :with_category, ->(category) { category.nil? ? all : where(category:) }
  scope :order_by_review_score, -> do
    joins(:reviews)
      .select('events.*, AVG(reviews.score) as average_score, DENSE_RANK() OVER (ORDER BY AVG(reviews.score) DESC) AS rank')
      .group(:id).order('average_score DESC, id DESC')
  end

  def not_ended?
    self.end_at > Time.current
  end

  def ended?
    self.end_at <= Time.current
  end
end
