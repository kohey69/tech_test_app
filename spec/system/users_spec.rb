require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user) }

  describe 'ヘッダー' do
    context 'ゲストユーザーの時' do
      it 'ルートページ・イベント一覧・レビューランキング一覧・イベント作成ボタン・ログイン・ログアウトのリンクが表示されること' do
        visit root_path

        within '.navbar' do
          expect(page).to have_link 'TechApp', href: root_path
          expect(page).to have_link 'イベント一覧', href: '#'
          expect(page).to have_link 'レビューランキング一覧', href: '#'
          expect(page).to have_link 'ログイン', href: new_user_session_path
          expect(page).to have_link '新規登録', href: new_user_registration_path
          expect(page).to have_link 'イベント作成', href: '#'
        end
      end
    end

    context 'ログイン済みの時' do
      before { login_as user, scope: :user }

      it 'ルートページ・イベント一覧・レビューランキング一覧・イベント作成ボタン・ドロップダウンのリンクが表示されること' do
        visit root_path

        within '.navbar' do
          expect(page).to have_link 'TechApp', href: root_path
          expect(page).to have_link 'イベント一覧', href: '#'
          expect(page).to have_link 'レビューランキング一覧', href: '#'
          expect(page).to have_link 'マイページ', href: '#'
          expect(page).to have_link '基本情報編集', href: edit_user_registration_path
          expect(page).to have_link 'ログアウト', href: destroy_user_session_path
          expect(page).to have_link 'イベント作成', href: '#'
        end
      end
    end
  end
end
