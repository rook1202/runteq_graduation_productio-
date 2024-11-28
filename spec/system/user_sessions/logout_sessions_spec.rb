# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'オートログイン', type: :system do
  let(:user) { create(:user) }

  describe 'ログアウト機能' do
    before do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      check 'ログイン状態を保持する'
      click_button 'ログイン'
      expect(page).to have_current_path(root_path) # ログイン確認
    end

    it 'クッキーとセッションが削除される' do
      click_link 'ログアウト'
      expect(page).to have_current_path(login_path)

      # sessionsテーブルの該当レコードが削除される
      session = Session.find_by(user_id: user.id)
      expect(session).to be_nil

      # クッキーが削除されている
      expect(get_rack_cookie('session_id')).to be_nil
      expect(get_rack_cookie('remember_token')).to be_nil
    end

    it 'クッキーが存在しない場合でも例外を発生させない' do
      session = Session.find_by(user_id: user.id)
      session&.destroy

      expect(page).to have_current_path(root_path) # ログイン確認
      click_link 'ログアウト'
      # 例外が発生せずにログアウトページにリダイレクトされる
      expect(page).to have_current_path(login_path)
      expect(page).to have_content('ログアウトしました')
    end
  end
end
