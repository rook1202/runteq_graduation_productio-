# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'メールアドレス変更メール送信ページ', type: :system do
  let(:user) { create(:user, email_change_token: 'example_token', email_change_token_expires_at: 2.hours.from_now) }

  before do
    login_as(user) # ユーザーがログインしている状態をセットアップ
  end

  it 'ページを開く' do
    visit settings_path
    click_on 'メールアドレス変更'
    expect(page).to have_current_path(new_email_change_path)
  end

  it 'アドレスが変更できる' do
    visit new_email_change_path
    fill_in 'new_email', with: 'change@example.com'
    click_button '変更'
    expect(page).to have_content('確認メールを送信しました。'), 'フラッシュメッセージ「確認メールを送信しました。」が表示されていません'

    # リンクに直接アクセス
    visit confirm_email_change_path(user.reload, token: user.email_change_token)

    # 動作確認
    expect(page).to have_content('メールアドレスの変更が完了しました。')
    expect(user.reload.email).to eq('change@example.com')
  end
end
