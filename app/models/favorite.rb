class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :user_id, uniqueness: { scope: :event }
  validate :must_not_be_created_by_user

  def must_not_be_created_by_user
    if self.event.user == self.user
      errors.add(:base, '主催者はお気に入りできません')
    end
  end
end
