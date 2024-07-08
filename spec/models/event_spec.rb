require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validate_timeliness' do
    context '開始日が今日以降で、終了日が開始日以降の時' do
      let(:event) { build(:event, :with_user, start_at: Time.zone.local(2024, 6, 13, 11, 0), end_at: Time.zone.local(2024, 6, 13, 12, 0)) }

      before { travel_to Time.zone.local(2024, 6, 13, 11, 0) }

      it '登録できること' do
        expect(event).to be_valid
      end
    end

    context '開始日時が空欄の時' do
      let(:event) { build(:event, :with_user, start_at: nil, end_at: Time.zone.local(2024, 6, 13, 12, 0)) }

      before { travel_to Time.zone.local(2024, 6, 13, 11, 0) }

      it '登録できないこと' do
        expect(event).not_to be_valid
      end
    end

    context '終了日時が空欄の時' do
      let(:event) { build(:event, :with_user, start_at: Time.zone.local(2024, 6, 13, 11, 0), end_at: nil) }

      before { travel_to Time.zone.local(2024, 6, 13, 11, 0) }

      it '登録できないこと' do
        expect(event).not_to be_valid
      end
    end

    context '開始日時が今日以降でない場合' do
      let(:event) { build(:event, :with_user, start_at: Time.zone.local(2024, 6, 13, 10, 59), end_at: Time.zone.local(2024, 6, 13, 12, 0)) }

      before { travel_to Time.zone.local(2024, 6, 13, 11, 0) }

      it '登録できないこと' do
        expect(event).not_to be_valid
      end
    end

    context '終了日時が開始日より後でない場合' do
      let(:event) { build(:event, :with_user, start_at: Time.zone.local(2024, 6, 13, 10, 0), end_at: Time.zone.local(2024, 6, 13, 10, 0)) }

      before { travel_to Time.zone.local(2024, 6, 13, 10, 0) }

      it '登録できないこと' do
        expect(event).not_to be_valid
      end
    end
  end
end
