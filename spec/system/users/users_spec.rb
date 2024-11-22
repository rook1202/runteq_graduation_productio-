# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  it 'ユーザーが新規作成できること' do
    visit '/users/new'
    expect do
      fill_in 'user_name', with: 'てすと'
      fill_in 'user_email', with: 'example@example.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '12345678'
      click_button '登録'
      # フラッシュメッセージを待機
      expect(page).to have_content('ユーザー登録が完了しました'), 'フラッシュメッセージが表示されていません'
    end.to change { User.count }.by(1)
    expect(current_path).to eq(root_path)
  end

  it 'ユーザーが新規作成できない' do
    visit '/users/new'
    expect do
      fill_in 'user_email', with: 'example@example.com'
      click_button '登録'
    end.to change { User.count }.by(0)
    expect(page).to have_content('ユーザー登録に失敗しました'), 'フラッシュメッセージ「ユーザー登録に失敗しました」が表示されていません'
    expect(page).to have_content('ユーザー名 を入力してください'), 'エラーメッセージ「姓を入力してください」が表示されていません'
    expect(page).to have_content('パスワード は6文字以上で入力してください'), 'フラッシュメッセージ「パスワード6文字以上で入力してください」が表示されていません'
  end
end
