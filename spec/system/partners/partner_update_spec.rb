# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パートナー情報', type: :system do
  let(:user) { create(:user) }

  describe '編集ページの表示' do
    let!(:partner_to_check) { create(:partner, owner: user) } # 詳細ページを確認する対象のパートナー

    before do
      login_as(user)
      click_on partner_to_check.name # パートナー名をクリックして詳細ページへ
      expect(page).to have_content(partner_to_check.name)
    end

    context '編集機能の確認' do
      it '基本情報の編集' do
        find('#edit_partner').click
        expect(page).to have_current_path(edit_partner_path(partner_to_check.id))
        fill_in 'partner_name', with: 'ネームチェンジ'
        fill_in 'partner_animal_type', with: '猫'
        click_button '更新'

        expect(page).to have_content('更新が完了しました')
        expect(page).to have_content('ネームチェンジ')
      end
    end
  end
end
