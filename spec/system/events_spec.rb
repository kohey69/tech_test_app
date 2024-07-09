require 'rails_helper'

RSpec.describe 'Events', type: :system do
  describe 'イベント一覧' do
    it '公開中かつ未開催のイベントのみ表示されていること' do
      create(:event, :with_user, title: '未開催の公開イベント', start_at: Time.current.since(1.hour))
      create(:event, :with_user, :unpublished, title: '未開催の非公開イベント', start_at: Time.current.since(1.hour))
      create(:event, :with_user, :skip_validate, title: '開催済みの公開イベント', start_at: Time.current.ago(1.hour))
      visit events_path

      expect(page).to have_content '未開催の公開イベント'
      expect(page).to have_no_content '未開催の非公開イベント'
      expect(page).to have_no_content '開催済みの公開イベント'
    end
  end

  describe 'イベント詳細' do
    let(:user) { create(:user) }
    let(:event) { create(:event, :with_user) }

    it 'ゲストユーザーが参加登録できないこと' do
      visit event_path(event)

      expect do
        click_on '参加する'
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end.not_to change(Participation, :count)
    end

    it '参加登録できること' do
      login_as user, scope: :user
      visit event_path(event)

      expect do
        click_on '参加する'
        expect(page).to have_content '新規登録しました'
      end.to change(Participation, :count).by(1)
    end

    it '主催者が参加登録できないこと' do
      login_as event.user, scope: :user
      visit event_path(event)

      expect do
        click_on '参加する'
        expect(page).to have_content 'イベント主催者は参加者として登録できません'
      end.not_to change(Participation, :count)
    end

    it 'お気に入り登録できること' do
      login_as user, scope: :user
      visit event_path(event)

      expect do
        click_on 'イベントをお気に入り'
        expect(page).to have_content '新規登録しました'
      end.to change(Favorite, :count).by(1)
      expect(page).to have_link 'お気に入りを解除する', href: event_favorite_path(event)
    end

    it 'お気に入りを解除できること' do
      create(:favorite, user:, event:)
      login_as user, scope: :user
      visit event_path(event)

      expect do
        click_on 'お気に入りを解除する'
        expect(page).to have_content '削除しました'
      end.to change(Favorite, :count).by(-1)
      expect(page).to have_link 'イベントをお気に入り', href: event_favorite_path(event)
    end

    it 'ゲストユーザーがお気に入りできないこと' do
      visit event_path(event)

      expect do
        click_on 'イベントをお気に入り'
        expect(page).to have_content 'ログインもしくはアカウント登録してください。'
      end.not_to change(Favorite, :count)
    end

    it '主催者がお気に入り登録できないこと' do
      login_as event.user, scope: :user
      visit event_path(event)

      expect do
        click_on 'イベントをお気に入り'
        expect(page).to have_content 'イベント主催者はお気に入り登録できません'
      end.not_to change(Favorite, :count)
    end
  end
end
