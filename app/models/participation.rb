class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event }
  validate :must_before_event_start_at

  def must_before_event_start_at
    if self.event.start_at < Time.current
      errors.add(:base, 'イベントは開始済みのため参加登録できません')
    end
  end
end
