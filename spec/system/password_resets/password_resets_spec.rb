# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パスワード再設定メール送信ページ', type: :system do
  let(:user) { create(:user) }

  it 'ログイン画面から入る（未ログイン）' do
    visit login_path
    click_on 'パスワードを忘れましたか？'
    expect(page).to have_current_path(new_password_reset_path)
  end

  it 'パスワードが変更できる' do
    visit new_password_reset_path
    fill_in 'email', with: user.email
    click_button 'メール送信'
    expect(page).to have_content('パスワード再設定のリンクをメールで送信しました。'), 'フラッシュメッセージ「パスワード再設定のリンクをメールで送信しました。」が表示されていません'
    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in 'user_password', with: '123456789'
    fill_in 'user_password_confirmation', with: '123456789'
    click_button 'パスワード変更'
    expect(page).to have_current_path(login_path)
  end
end
