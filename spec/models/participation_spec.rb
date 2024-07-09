require 'rails_helper'

RSpec.describe Participation, type: :model do
  describe '#must_before_event_start_at' do
    context 'イベント開始日時よりも参加登録日時が遅い場合' do
      let(:event) { create(:event, :skip_validate, :with_user, start_at: Time.zone.local(2024, 6, 18, 10, 0)) }

      before do
        travel_to Time.zone.local(2024, 6, 18, 11, 0)
      end

      it '登録できないこと' do
        participation = build(:participation, :with_user, event:)
        expect(participation).not_to be_valid
      end
    end

    context 'イベント開始日時よりも参加登録日時が早い場合' do
      let(:event) { create(:event, :skip_validate, :with_user, start_at: Time.zone.local(2024, 6, 18, 10, 0)) }

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
