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

  describe '#not_ended' do
    context '現在日時が7月1日0時の場合' do
      before do
        travel_to Time.zone.local(2024, 7, 1, 0, 0)
        create(:event, :skip_validate, :with_user, title: '終了前のイベント', end_at: Time.zone.local(2024, 7, 1, 0, 1))
        create(:event, :skip_validate, :with_user, title: '終了後のイベント', end_at: Time.zone.local(2024, 7, 1, 0, 0))
      end

      it '現在時刻以降に終了したイベントは取得されないこと' do
        expect(Event.not_ended.pluck(:title)).to contain_exactly('終了前のイベント')
      end
    end
  end

  describe '#order_by_start_at' do
    before do
      create(:event, :skip_validate, :with_user, title: '7月9日のイベント', start_at: Time.zone.local(2024, 7, 9))
      create(:event, :skip_validate, :with_user, title: '7月10日のイベント', start_at: Time.zone.local(2024, 7, 10))
      create(:event, :skip_validate, :with_user, title: '7月11日のイベント', start_at: Time.zone.local(2024, 7, 11))
    end

    it 'お気に入りされたイベントの中で、開始日時順に取得できること' do
      expect(Event.order_by_start_at.pluck(:title)).to contain_exactly('7月9日のイベント', '7月10日のイベント', '7月11日のイベント')
    end
  end

  describe 'favorite_eventsデフォルトのスコープ' do
    let(:user) { create(:user) }

    before do
      event1 = create(:event, :with_user, title: '最近お気に入りされたイベント')
      event2 = create(:event, :with_user, title: '昔お気に入りされたイベント')
      _event3 = create(:event, :with_user, title: 'お気に入りされていないイベント')
      create(:favorite, user:, event: event1, created_at: Time.zone.local(2024, 7, 1))
      create(:favorite, user:, event: event2, created_at: Time.zone.local(2023, 6, 30))
    end

    it 'お気に入りされた公開イベントの中で、最近お気に入りした順に取得できること' do
      expect(user.favorite_events.pluck(:title)).to contain_exactly('最近お気に入りされたイベント', '昔お気に入りされたイベント')
    end
  end

  describe '#order_by_participations_count' do
    context '参加者数が重複していない時' do
      before do
        event1 = create(:event, :with_user, title: '参加者が5人のイベント')
        event2 = create(:event, :with_user, title: '参加者が3人のイベント')
        event3 = create(:event, :with_user, title: '参加者が1人のイベント')
        _event4 = create(:event, :with_user, title: '参加者が0人のイベント')
        create_list(:participation, 5, :with_user, event: event1)
        create_list(:participation, 3, :with_user, event: event2)
        create_list(:participation, 1, :with_user, event: event3)
      end

      it '参加者が多い順に並べられること' do
        expect(Event.order_by_participations_count.pluck(:title)).to contain_exactly('参加者が5人のイベント', '参加者が3人のイベント', '参加者が1人のイベント')
      end
    end

    context '参加者数が重複している時' do
      before do
        event1 = create(:event, :with_user, title: '開始日時が7月1日で参加者が3人のイベント', start_at: Time.current.days_since(1))
        event2 = create(:event, :with_user, title: '開始日時が7月2日で参加者が3人のイベント', start_at: Time.current.days_since(2))
        event3 = create(:event, :with_user, title: '開始日時が7月3日で参加者が3人のイベント', start_at: Time.current.days_since(3))
        _event4 = create(:event, :with_user, title: '開始日時が7月1日で参加者が0人のイベント', start_at: Time.current.days_since(1))
        create_list(:participation, 3, :with_user, event: event1)
        create_list(:participation, 3, :with_user, event: event2)
        create_list(:participation, 3, :with_user, event: event3)
      end

      it '開始日が早い順に並べられること' do
        expect(Event.order_by_participations_count.pluck(:title)).to contain_exactly('開始日時が7月1日で参加者が3人のイベント', '開始日時が7月2日で参加者が3人のイベント', '開始日時が7月3日で参加者が3人のイベント')
      end
    end
  end

  describe '#not_ended?' do
    before { travel_to Time.zone.local(2024, 6, 13, 0, 0) }

    context 'イベント終了前の場合' do
      let(:event) { create(:event, :skip_validate, :with_user, end_at: Time.zone.local(2024, 6, 13, 0, 1)) }

      it 'trueを返すこと' do
        expect(event.not_ended?).to be true
      end
    end

    context 'イベント終了後の場合' do
      let(:event) { create(:event, :skip_validate, :with_user, end_at: Time.zone.local(2024, 6, 13, 0, 0)) }

      it 'falseを返すこと' do
        expect(event.not_ended?).to be false
      end
    end
  end
end
