require 'rails_helper'

RSpec.describe 'My::Events', type: :system do
  let(:user) { create(:user) }

  describe 'マイページ： イベント一覧' do
    it 'マイページのナビゲーションが表示されていること' do
      login_as user, scope: :user
      visit my_events_path

      expect(page).to have_link '作成したイベント', href: my_events_path
      expect(page).to have_link 'お気に入りしたイベント', href: my_favorite_events_path
      expect(page).to have_link '参加予定のイベント', href: my_participating_events_path
      expect(page).to have_link '参加済みのイベント', href: my_participated_events_path
    end

    it '公開・非公開のイベント一覧が表示できること' do
      login_as user, scope: :user
      published_event = create(:event, user:, title: '公開イベント')
      unpublished_event = create(:event, :unpublished, user:, title: '非公開イベント')
      visit my_events_path

      expect(page).to have_content '公開イベント'
      expect(page).to have_link '詳細', href: my_event_path(published_event)
      expect(page).to have_content '非公開イベント'
      expect(page).to have_link '詳細', href: my_event_path(unpublished_event)
    end

    it 'ゲストユーザーがページ遷移できないこと' do
      visit my_events_path

      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(page).to have_current_path new_user_session_path
    end
  end

  describe 'マイページ： イベント詳細' do
    it '公開バッジが表示されること' do
      event = create(:event, user:)
      login_as user, scope: :user
      visit my_event_path(event)

      expect(page).to have_content '公開'
    end

    it '非公開バッジが表示されること' do
      event = create(:event, :unpublished, user:)
      login_as user, scope: :user
      visit my_event_path(event)

      expect(page).to have_content '非公開'
    end

    it '編集・削除リンクが表示されていること' do
      event = create(:event, user:)
      login_as user, scope: :user
      visit my_event_path(event)

      expect(page).to have_link '編集する', href: edit_my_event_path(event)
      expect(page).to have_link '削除する', href: my_event_path(event)
    end
  end

  describe 'マイページ： イベント編集' do
    let(:event) { create(:event, user:) }

    it '開始日時を今日より前の日付で更新できること' do
      login_as user, scope: :user
      visit edit_my_event_path(event)

      fill_in '開始日時', with: '2024-04-11-T14:08:00'
      fill_in '終了日時', with: '2024-04-11-T14:09:00'
      click_on '更新する'

      expect(page).to have_content '更新しました'
    end

    it '終了日時を開始日時より後の日時で更新できないこと' do
      login_as user, scope: :user
      visit edit_my_event_path(event)

      fill_in '開始日時', with: '2024-04-11-T14:08:00'
      fill_in '終了日時', with: '2024-04-11-T14:07:00'
      click_on '更新する'

      expect(page).to have_content '失敗しました'
    end
  end

  describe 'マイページ： 参加予定のイベント' do
    it 'ゲストユーザーが遷移できないこと' do
      visit my_participating_events_path

      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(page).to have_current_path new_user_session_path
    end

    it '参加予定で開始済みのイベントが表示されないこと' do
      travel_to Time.zone.local(2024, 7, 1, 0, 0)
      event1 = create(:event, :with_user, title: '開始されていない参加予定のイベント', start_at: Time.zone.local(2024, 7, 1, 0, 1))
      event2 = create(:event, :unpublished, :with_user, title: '開始されていない参加予定の非公開イベント', start_at: Time.zone.local(2024, 7, 1, 0, 1))
      event3 = create(:event, :skip_validate, :with_user, title: '開始されている参加予定のイベント', start_at: Time.zone.local(2024, 7, 1, 0, 0))
      _event4 = create(:event, :with_user, title: '開始されていない参加しないイベント', start_at: Time.zone.local(2024, 7, 1, 1))
      create(:participation, user:, event: event1)
      create(:participation, user:, event: event2)
      create(:participation, :skip_validate, user:, event: event3)
      login_as user, scope: :user
      visit my_participating_events_path

      expect(page).to have_content '開始されていない参加予定のイベント'
      expect(page).to have_no_content '開始されていない参加予定の非公開イベント'
      expect(page).to have_no_content '開始れている参加予定のイベント'
      expect(page).to have_no_content '開始されていない参加しないイベント'
    end
  end

  describe 'マイページ： 参加済みのイベント' do
    it 'ゲストユーザーが遷移できないこと' do
      visit my_participated_events_path

      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(page).to have_current_path new_user_session_path
    end

    it '参加登録していて終了していないイベントが表示されないこと' do
      travel_to Time.zone.local(2024, 7, 1, 0, 0)
      event1 = create(:event, :skip_validate, :with_user, title: '終了前の参加予定のイベント', end_at: Time.zone.local(2024, 7, 1, 0, 1))
      event2 = create(:event, :skip_validate, :unpublished, :with_user, title: '終了前の参加予定の非公開イベント', end_at: Time.zone.local(2024, 7, 1, 0, 1))
      event3 = create(:event, :skip_validate, :with_user, title: '終了後の参加予定のイベント', end_at: Time.zone.local(2024, 7, 1, 0, 0))
      _event4 = create(:event, :skip_validate, :with_user, title: '終了前の参加しないイベント', end_at: Time.zone.local(2024, 7, 1, 1))
      create(:participation, user:, event: event1)
      create(:participation, user:, event: event2)
      create(:participation, :skip_validate, user:, event: event3)
      login_as user, scope: :user
      visit my_participating_events_path

      expect(page).to have_content '終了前の参加予定のイベント'
      expect(page).to have_no_content '終了前の参加予定の非公開イベント'
      expect(page).to have_no_content '終了後の参加予定のイベント'
      expect(page).to have_no_content '終了前の参加しないイベント'
    end
  end
end
