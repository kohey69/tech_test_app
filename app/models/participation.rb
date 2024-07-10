class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event }
  validate :must_before_event_end_at

  def must_before_event_end_at
    if self.event.end_at <= Time.current
      errors.add(:base, 'イベントは終了済みのため参加登録できません')
    end
  end
end
