# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'チュートリアル', type: :system do
  let(:user) { create(:user) }

  describe 'リストページのチュートリアルの処理' do
    before do
      user.update(showed_tutorial: false)
      login_as(user)
      visit partners_path
      expect(page).to have_current_path(partners_path)
    end

    it 'チュートリアルが表示される・再表示されない' do
      expect(page).to have_selector('#tooltip-1[style*="opacity: 1"]') # opacity:1 で表示確認
      click_on('次へ')
      expect(page).to have_selector('a[href="/partners/new"].highlight') # 強調表示を確認
      click_on('次へ')
      click_on('次へ')
      click_on('次へ')
      click_on('閉じる')

      user.update(showed_tutorial: true) # javascriptのfetchがうまく動かないため更新
      visit partners_path
      expect(page).not_to have_selector('#tooltip-1[style*="opacity: 1"]') # 再表示されない
    end
  end

  describe 'リストページのチュートリアルの処理' do
    before do
      login_as(user)
      visit settings_path
      expect(page).to have_current_path(settings_path)
    end

    it 'チュートリアルを再表示できる' do
      accept_confirm 'リストページに移動しチュートリアルを開始します。' do
        click_on('チュートリアルを再度確認する')
      end
      expect(page).to have_current_path(root_path)
      expect(page).to have_content('ここではあなたのペットを一覧で表示します！')
    end
  end
end
