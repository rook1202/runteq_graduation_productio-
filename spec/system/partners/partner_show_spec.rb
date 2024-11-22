# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パートナー情報', type: :system do
  let(:user) { create(:user) }

  describe '詳細ページの表示' do
    let!(:partner_to_check) { create(:partner, owner: user) } # 詳細ページを確認する対象のパートナー

    before do
      login_as(user)
      visit partners_path
      expect(current_path).to eq(partners_path)
      click_on partner_to_check.name # パートナー名をクリックして詳細ページへ
      expect(page).to have_content(partner_to_check.name)
    end

    it '詳細ページが正しく表示される' do
      # パートナーの基本情報を確認
      expect(page).to have_content(partner_to_check.name)
      expect(page).to have_content(partner_to_check.animal_type)
      expect(page).to have_content(partner_to_check.breed) if partner_to_check.breed.present?
      expect(page).to have_content("性別：#{partner_to_check.gender_in_japanese}")
      expect(page).to have_content("年齢：#{partner_to_check.age}歳") if partner_to_check.age.present?
      expect(page).to have_content("体重：#{partner_to_check.weight}") if partner_to_check.weight.present?

      # 関連情報がまだ更新されていないことを確認
      expect(page).to have_content('まだごはんに関する登録はありません。')
      expect(page).to have_content('まださんぽに関する登録はありません。')
      expect(page).to have_content('まだおくすりに関する登録はありません。')
    end
  end
end
