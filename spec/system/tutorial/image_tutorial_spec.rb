# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '画像による使い方説明', type: :system do
  let(:user) { create(:user) }

  describe '説明モーダル表示確認' do
    before do
      login_as(user)
      visit settings_path
      expect(page).to have_current_path(settings_path)
    end

    it '説明モーダルが4ページ表示できる' do
      click_on('使い方や注意点を確認する')

      within('#tutorialModal') do
        expect(page).to have_content('ステップ 1')
        click_on('次へ')
        expect(page).to have_selector("img[src='#{ActionController::Base.helpers.asset_path('step2.png')}']")
        click_on('次へ')
        expect(page).to have_content('共有した場合相手からはこう見えます！')
        click_on('次へ')
        expect(page).to have_content('ステップ 4')
        click_on('閉じる')
      end
      expect(page).not_to have_content('ステップ 4')
    end
  end
end
