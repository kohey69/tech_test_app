require 'rails_helper'

RSpec.describe 'レビューランキング', type: :system do
  describe '総合ランキング' do
    before do
      event1 = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が4公開イベント', end_at: Time.zone.local(2024, 7, 1))
      event2 = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が2の公開イベント', end_at: Time.zone.local(2024, 7, 1))
      event3 = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が3の公開イベント', end_at: Time.zone.local(2024, 7, 1))
      event4 = create(:event, :skip_validate, :unpublished, :with_user, title: 'レビュー評価平均が3の非公開イベント', end_at: Time.zone.local(2024, 7, 1))
      _event5 = create(:event, :skip_validate, :unpublished, :with_user, title: 'レビューがない公開イベント', end_at: Time.zone.local(2024, 7, 1))
      _event6 = create(:event, :skip_validate, :unpublished, :with_user, title: 'レビューがない非公開イベント', end_at: Time.zone.local(2024, 7, 1))
      create(:review, :with_user, event: event1, score: 5)
      create(:review, :with_user, event: event1, score: 3)
      create(:review, :with_user, event: event2, score: 2)
      create(:review, :with_user, event: event3, score: 3)
      create(:review, :with_user, event: event4, score: 3)
    end

    it '公開中のイベントランキングが表示できる' do
      visit review_ranking_events_path

      expect(page).to have_content 'レビュー評価平均が4公開イベント'
      expect(page).to have_content 'レビュー評価平均が2の公開イベント'
      expect(page).to have_content 'レビュー評価平均が3の公開イベント'
      expect(page).not_to have_content 'レビュー評価平均が3の非公開イベント'
      expect(page).not_to have_content 'レビューがない公開イベント'
      expect(page).not_to have_content 'レビューがない非公開イベント'
    end
  end

  describe 'カテゴリー別ランキング' do
    before do
      music_event = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が5の音楽イベント', end_at: Time.zone.local(2024, 7, 1), category: :music)
      sports_event = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が4のスポーツイベント', end_at: Time.zone.local(2024, 7, 1), category: :sports)
      business_event = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が3のビジネスイベント', end_at: Time.zone.local(2024, 7, 1), category: :business)
      hobby_event = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が2の趣味イベント', end_at: Time.zone.local(2024, 7, 1), category: :hobby)
      other_event = create(:event, :skip_validate, :with_user, title: 'レビュー評価平均が1のその他イベント', end_at: Time.zone.local(2024, 7, 1), category: :other)
      create(:review, :with_user, event: music_event, score: 5)
      create(:review, :with_user, event: sports_event, score: 4)
      create(:review, :with_user, event: business_event, score: 3)
      create(:review, :with_user, event: hobby_event, score: 2)
      create(:review, :with_user, event: other_event, score: 1)
    end

    it '総合レビューランキングが表示できる' do
      visit review_ranking_events_path

      expect(page).to have_content 'レビュー評価平均が5の音楽イベント'
      expect(page).to have_content 'レビュー評価平均が4のスポーツイベント'
      expect(page).to have_content 'レビュー評価平均が3のビジネスイベント'
      expect(page).to have_content 'レビュー評価平均が2の趣味イベント'
      expect(page).to have_content 'レビュー評価平均が1のその他イベント'
    end

    it '音楽ランキングが表示できる' do
      visit review_ranking_events_path(category: :music)

      expect(page).to have_content 'レビュー評価平均が5の音楽イベント'
      expect(page).to have_no_content 'レビュー評価平均が4のスポーツイベント'
      expect(page).to have_no_content 'レビュー評価平均が3のビジネスイベント'
      expect(page).to have_no_content 'レビュー評価平均が2の趣味イベント'
      expect(page).to have_no_content 'レビュー評価平均が1のその他イベント'
    end

    it 'スポーツランキングが表示できる' do
      visit review_ranking_events_path(category: :sports)

      expect(page).to have_no_content 'レビュー評価平均が5の音楽イベント'
      expect(page).to have_content 'レビュー評価平均が4のスポーツイベント'
      expect(page).to have_no_content 'レビュー評価平均が3のビジネスイベント'
      expect(page).to have_no_content 'レビュー評価平均が2の趣味イベント'
      expect(page).to have_no_content 'レビュー評価平均が1のその他イベント'
    end

    it 'ビジネスランキングが表示できる' do
      visit review_ranking_events_path(category: :business)

      expect(page).to have_no_content 'レビュー評価平均が5の音楽イベント'
      expect(page).to have_no_content 'レビュー評価平均が4のスポーツイベント'
      expect(page).to have_content 'レビュー評価平均が3のビジネスイベント'
      expect(page).to have_no_content 'レビュー評価平均が2の趣味イベント'
      expect(page).to have_no_content 'レビュー評価平均が1のその他イベント'
    end

    it '趣味ランキングが表示できる' do
      visit review_ranking_events_path(category: :hobby)

      expect(page).to have_no_content 'レビュー評価平均が5の音楽イベント'
      expect(page).to have_no_content 'レビュー評価平均が4のスポーツイベント'
      expect(page).to have_no_content 'レビュー評価平均が3のビジネスイベント'
      expect(page).to have_content 'レビュー評価平均が2の趣味イベント'
      expect(page).to have_no_content 'レビュー評価平均が1のその他イベント'
    end

    it 'その他ランキングが表示できる' do
      visit review_ranking_events_path(category: :other)

      expect(page).to have_no_content 'レビュー評価平均が5の音楽イベント'
      expect(page).to have_no_content 'レビュー評価平均が4のスポーツイベント'
      expect(page).to have_no_content 'レビュー評価平均が3のビジネスイベント'
      expect(page).to have_no_content 'レビュー評価平均が2の趣味イベント'
      expect(page).to have_content 'レビュー評価平均が1のその他イベント'
    end
  end
end
