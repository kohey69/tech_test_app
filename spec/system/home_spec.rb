require 'rails_helper'

RSpec.describe 'Home', type: :system do
  describe 'イベント一覧' do
    it '公開中かつ未開催のイベントのみ表示されていること' do
      create(:event, :with_participation, :with_user, title: '未開催の公開イベント', start_at: Time.current.since(1.hour))
      create(:event, :with_participation, :with_user, :unpublished, title: '未開催の非公開イベント', start_at: Time.current.since(1.hour))
      create(:event, :with_participation, :with_user, :skip_validate, title: '開催済みの公開イベント', start_at: Time.current.ago(1.hour))
      visit root_path

      expect(page).to have_content '未開催の公開イベント'
      expect(page).to have_no_content '未開催の非公開イベント'
      expect(page).to have_no_content '開催済みの公開イベント'
    end
  end
end
