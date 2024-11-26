# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '設定ページ', type: :system do
  let(:user) { create(:user) }

  describe '設定ページの表示' do
    before do
      login_as(user)
      visit settings_path
    end

    it '設定ページが正しく表示される' do
      expect(page).to have_current_path(settings_path), '現在のパスが settings_path ではありません'
      expect(page).to have_content('共有中のユーザー'), '「共有中のユーザー」が表示されていません'
      expect(page).to have_content('ログイン設定'), '「ログイン設定」が表示されていません'
    end
  end

  describe '設定ページへのアクセス失敗' do
    it 'ログインせずに設定ページを開く' do
      visit settings_path
      expect(page).to have_current_path(login_path), '未ログイン時にlogin_pathにリダイレクトされていません'
      expect(page).to have_content('ログインしてください'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
    end
  end
end
