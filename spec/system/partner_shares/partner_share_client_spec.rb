# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '共有機能（依頼側）', type: :system do
  let(:user1) { create(:user) }
  let!(:partner) { create(:partner, owner: user1) }

  describe 'トークン発行' do
    before do
      login_as(user1)
    end

    it 'すべてのパートナーを共有' do
      visit partners_path # トークン発行画面
      click_button 'すべてのパートナーを共有'
      expect(page).to have_content('共有方法選択'), 'モーダルが表示されていません。'

      # トークン作成処理を直接呼び出し
      host_url = Capybara.app_host
      service = ShareService.new(host_url, user1, nil)
      service.create_share

      # トークンがDBに保存されているか確認
      expect(Token.count).to eq(1)
      token = Token.last
      expect(token.user_id).to eq(user1.id)
      expect(token.partner_id).to be_nil # すべてのパートナーを共有の場合、partner_idはnil
    end

    it '特定のパートナーを共有' do
      visit partner_path(partner)
      click_button 'このパートナーを共有'
      expect(page).to have_content('共有方法選択'), 'モーダルが表示されていません。'

      # トークン作成処理を直接呼び出し
      host_url = Capybara.app_host
      service = ShareService.new(host_url, user1, partner)
      service.create_share

      # トークンがDBに保存されているか確認
      expect(Token.count).to eq(1)
      token = Token.last
      expect(token.user_id).to eq(user1.id)
      expect(token.partner_id).to eq(partner.id) # 特定のパートナーを共有の場合
    end
  end
end
