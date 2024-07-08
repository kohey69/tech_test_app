require 'rails_helper'

RSpec.describe 'My::Events', type: :system do
  let(:user) { create(:user) }

  describe 'マイページ： イベント一覧' do
    it 'マイページのナビゲーションが表示されていること' do
      login_as user, scope: :user
      visit my_events_path

      expect(page).to have_link '作成したイベント', href: my_events_path
      expect(page).to have_link 'お気に入りしたイベント', href: '#'
      expect(page).to have_link '参加予定のイベント', href: '#'
      expect(page).to have_link '参加済みのイベント', href: '#'
    end

    it '公開・非公開のイベント一覧が表示できること' do
      login_as user, scope: :user
      _published_event = create(:event, user:, title: '公開イベント')
      _unpublished_event = create(:event, :unpublished, user:, title: '非公開イベント')
      visit my_events_path

      expect(page).to have_content '公開イベント'
      expect(page).to have_link '詳細', href: '#'
      expect(page).to have_content '非公開イベント'
    end

    it 'ゲストユーザーがページ遷移できないこと' do
      visit my_events_path

      expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      expect(page).to have_current_path new_user_session_path
    end
  end
end
