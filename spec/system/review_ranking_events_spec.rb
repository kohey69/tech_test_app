require 'rails_helper'

RSpec.describe 'レビューランキング', type: :system do
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

  it '総合レビューランキングが表示できる' do
    visit review_ranking_events_path

    expect(page).to have_content 'レビュー評価平均が4公開イベント'
    expect(page).to have_content 'レビュー評価平均が2の公開イベント'
    expect(page).to have_content 'レビュー評価平均が3の公開イベント'
    expect(page).not_to have_content 'レビュー評価平均が3の非公開イベント'
    expect(page).not_to have_content 'レビューがない公開イベント'
    expect(page).not_to have_content 'レビューがない非公開イベント'
  end
end
