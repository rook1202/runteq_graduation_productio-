# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パートナーごはん情報', type: :system do
  let(:user) { create(:user) }
  let!(:partner_to_check) { create(:partner, owner: user) } # 詳細ページを確認する対象のパートナー

  describe '編集ページの表示' do
    before do
      login_as(user)
      click_on partner_to_check.name # パートナー名をクリックして詳細ページへ
      expect(page).to have_content(partner_to_check.name)
    end

    it 'ごはん情報の編集' do
      food = partner_to_check.foods.first
      find("#edit_food_#{food.id}").click
      expect(page).to have_current_path(edit_partner_food_path(partner_to_check.id, food.id))

      fill_in 'food_manufacturer', with: 'フードメーカー名'
      click_button '編集'

      expect(page).to have_content('フードメーカー名') # 情報が更新されているか
    end

    it 'ごはん情報の追加' do
      find('#add_food').click
      expect(page).to have_content('ごはん 2') # 情報が追加されているか
      click_on('ごはん 2') # テキストでタブをクリック
      expect(page).to have_content('まだごはんに関する登録はありません。')
    end

    it 'ごはん情報の削除' do
      find('#add_food').click
      expect(page).to have_content('ごはん 2')
      find('#destroy_food').click
      expect(page).to have_content('どれを削除しますか？')

      within('#deleteFoodModal') do
        all('a', text: '削除').first.click # 一番上の削除ボタンをクリック
      end
      expect(page).to have_content('どれを削除しますか？')
      find('.btn-close[data-bs-dismiss="modal"]').click
      expect(page).not_to have_content('ごはん 2')
    end
  end
end
