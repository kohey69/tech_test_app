require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'サインアップ' do
    it '新規登録できること' do
      visit new_user_registration_path

      fill_in 'ユーザー名', with: '田中太郎'
      fill_in 'メールアドレス', with: 'sample@example.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'

      expect do
        click_on '登録する'
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end.to change(User, :count).by(1)
      expect(page).to have_current_path root_path
    end

    it 'プロフィール写真を登録できること' do
      visit new_user_registration_path

      fill_in 'ユーザー名', with: '田中太郎'
      fill_in 'メールアドレス', with: 'sample@example.com'
      attach_file 'プロフィール写真', Rails.root.join('spec/support/files/sample_avatar.svg')
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'

      expect do
        click_on '登録する'
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end.to change(User, :count).by(1)
      expect(page).to have_current_path root_path
      expect(User.last.avatar).to be_attached
      expect(User.last.avatar.filename.to_s).to eq 'sample_avatar.svg'
    end

    it 'プロフィール画像を添付してバリデーションエラーとなっても添付した画像が表示できること', :js do
      visit new_user_registration_path

      fill_in 'ユーザー名', with: '田中太郎'
      fill_in 'メールアドレス', with: 'sample@example.com'
      attach_file 'プロフィール写真', Rails.root.join('spec/support/files/sample_avatar.png')
      fill_in 'user[password]', with: 'password'

      expect do
        click_on '登録する'
      end.not_to change(User, :count)
      expect(page).to have_content 'エラーがあります。確認してください。'
      expect(page).to have_current_path new_user_registration_path
      expect(page).to have_selector "img[alt='添付画像']"
    end

    it 'プロフィール画像の拡張子にバリデーションがかかっていること', :js do
      visit new_user_registration_path

      fill_in 'ユーザー名', with: '田中太郎'
      fill_in 'メールアドレス', with: 'sample@example.com'
      attach_file 'プロフィール写真', Rails.root.join('spec/support/files/sample_avatar.svg')
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'

      expect do
        click_on '登録する'
      end.not_to change(User, :count)
      expect(page).to have_content 'エラーがあります。確認してください。'
      expect(page).to have_current_path new_user_registration_path
      expect(page).to have_content 'プロフィール写真のContent Typeが不正です'
      expect(page).not_to have_selector "img[alt='添付画像']"
    end
  end

  describe 'アカウント有効化' do
    before { create(:user, :unconfirmed, email: 'sample@example.com') }

    it '有効化メールからアカウントの有効化できること' do
      mail = ActionMailer::Base.deliveries.last

      expect(mail.to).to eq ['sample@example.com']
      expect(mail.from).to eq ['noreply@example.com']
      expect(mail.subject).to eq '【重要】アカウント有効化について'
      expect(mail.body).to match 'アカウントを有効化する'
    end

    it '有効化メールが再送できること' do
      visit new_user_confirmation_path

      fill_in 'メールアドレス', with: 'sample@example.com'

      expect do
        click_on 'アカウント有効化メールを再送する'
        expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡します。'
      end.to change { ActionMailer::Base.deliveries.size }.by(1)

      mail = ActionMailer::Base.deliveries.last

      expect(mail.to).to eq ['sample@example.com']
      expect(mail.from).to eq ['noreply@example.com']
      expect(mail.subject).to eq '【重要】アカウント有効化について'
      expect(mail.body).to match 'アカウントを有効化する'
    end
  end

  describe 'パスワードリセット' do
    before { create(:user, email: 'sample@example.com') }

    it 'パスワードリセットメールを送信できること' do
      visit new_user_password_path

      fill_in 'メールアドレス', with: 'sample@example.com'

      expect do
        click_on 'パスワードの再設定メールを送信する'
        expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
      end.to change { ActionMailer::Base.deliveries.size }.by(1)

      mail = ActionMailer::Base.deliveries.last

      expect(mail.to).to eq ['sample@example.com']
      expect(mail.from).to eq ['noreply@example.com']
      expect(mail.subject).to eq '【重要】パスワードの再設定について'
      expect(mail.body).to match 'パスワードを変更する'
    end
  end

  describe 'ログイン・ログアウト' do
    let!(:user) { create(:user, email: 'sample@example.com') }

    it 'ログインできること' do
      visit new_user_session_path

      fill_in 'メールアドレス', with: 'sample@example.com'
      fill_in 'パスワード', with: 'password'
      click_on 'ログインする'

      expect(page).to have_content 'ログインしました。'
      expect(page).to have_current_path root_path
    end

    it 'ログアウトできること' do
      login_as user, scope: :user

      visit root_path

      click_on 'ログアウト'

      expect(page).to have_content 'ログアウトしました。'
      expect(page).to have_current_path root_path
    end
  end

  describe 'ヘッダー' do
    let(:user) { create(:user) }

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
