# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'オートログイン', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン機能' do
    it 'Remember Meをチェックした場合、セッションとクッキーが正しく設定される' do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      check 'ログイン状態を保持する'
      click_button 'ログイン'
      expect(page).to have_current_path(root_path) # ログイン確認

      # ログイン成功後、sessionsテーブルにレコードが作成される
      session = Session.find_by(user_id: user.id)
      expect(session).to be_present

      # クッキーにsession_idとremember_tokenが設定されている
      expect(get_rack_cookie('session_id')).to be_present
      expect(get_rack_cookie('remember_token')).to be_present
    end

    it 'Remember Meをチェックしない場合、セッションとクッキーが設定されない' do
      visit login_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: '12345678'
      uncheck 'ログイン状態を保持する'
      click_button 'ログイン'
      expect(page).to have_current_path(root_path) # ログイン確認

      # ログイン成功後、sessionsテーブルにレコードが作成されない
      session = Session.find_by(user_id: user.id)
      expect(session).to be_nil

      # クッキーが設定されていない
      expect(get_rack_cookie('session_id')).to be_nil
      expect(get_rack_cookie('remember_token')).to be_nil
    end
  end
end
