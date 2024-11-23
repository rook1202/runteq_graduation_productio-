# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ユーザー名変更ページ', type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit name_change_settings_path
  end

    it 'ユーザー名が変更できる' do  
      expect(page).to have_current_path(name_change_settings_path),'ユーザー名変更ページが表示されていません。'
        fill_in 'user_name', with: 'ユーザーネームチェンジ'
        click_button '変更'
      expect(page).to have_current_path(settings_path),'設定ページが表示されていません。'
      expect(page).to have_content('変更が完了しました'), 'フラッシュメッセージ「変更が完了しました」が表示されていません'
    end

end