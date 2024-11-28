# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'オートログイン', type: :system do
  let(:user) { create(:user) }

  describe 'セッション切れ' do
    it '有効期限が切れるとログアウトされる' do
      # セッションを作成し、有効期限を過去に設定
      session_data = Session.create_session_for(user, '127.0.0.1')
      session = session_data[:session]
      session.update!(expires_at: 1.hour.ago)

      visit root_path

      # セッション切れのためログインページにリダイレクト
      expect(current_path).to eq(login_path)
      expect(page).to have_content('ログインしてください。')
    end
  end
end
