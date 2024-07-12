require 'rails_helper'

RSpec.describe Participation, type: :model do
  describe '#must_before_event_end_at' do
    context '参加登録がイベント終了後の場合' do
      let(:event) { create(:event, :skip_validate, :with_user, end_at: Time.zone.local(2024, 6, 18, 11, 0)) }

      before do
        travel_to Time.zone.local(2024, 6, 18, 11, 0)
      end

      it '登録できないこと' do
        participation = build(:participation, :with_user, event:)
        expect(participation).not_to be_valid
      end
    end

    context '参加登録がイベント終了前場合' do
      let(:event) { create(:event, :skip_validate, :with_user, end_at: Time.zone.local(2024, 6, 18, 10, 0)) }

      before do
        travel_to Time.zone.local(2024, 6, 18, 9, 0)
      end

      it '登録できること' do
        participation = build(:participation, :with_user, event:)
        expect(participation).to be_valid
      end
    end
  end
end
