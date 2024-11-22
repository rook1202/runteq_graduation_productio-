# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パートナー情報', type: :system do
  let(:user) { create(:user) }

  describe 'パートナーリストページ' do
    # 関連データも含めて2つのパートナーを作成
    let!(:partners) { create_list(:partner, 2, owner: user) }
    before do
      login_as(user)
      visit partners_path
      expect(current_path).to eq(partners_path)
    end

    it 'パートナーが一覧に正しく表示される' do
      # 画面上にパートナー名が2つ表示されていることを確認
      partners.each do |partner|
        expect(page).to have_content(partner.name) # パートナー名が表示されているか
        expect(page).to have_content(partner.owner.name) # パートナーのオーナーの名前
        expect(page).to have_content(partner.animal_type) # 動物の種類が表示されているか
      end

      # パートナーが2件表示されていることを確認
      expect(page).to have_css('.col-12.col-md-6.mb-4', count: 2)
    end
  end
end
