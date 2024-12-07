# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '共有機能（受理側）', type: :system do
  let(:user1) { create(:user) }
  let(:user2) { create(:user, :other_user) }

  describe '共有の成立' do
    before do
      login_as(user2)
    end

    it 'すべてのパートナーを共有' do
      # user1がすべてのパートナーを共有するトークンを発行
      create_list(:partner, 2, owner: user1) # user1に2つのパートナーを作成
      token = create_token(user1)

      visit confirm_share_path(token: token.token) # トークン付きURLにアクセス
      expect(page).to have_content '2件のパートナーを共有しました！'
      expect(page).to have_css('.col-12.col-md-6.mb-4', count: 2) # パートナーが2件表示されていることを確認
      expect(PartnerShare.count).to eq(2) # 共有がDBに登録されたか確認
    end

    it '特定のパートナーを共有' do
      # user1が特定のパートナーを共有するトークンを発行
      partner = create(:partner, owner: user1)
      token = create_token(user1, partner)

      visit confirm_share_path(token: token.token) # トークン付きURLにアクセス
      expect(page).to have_content '共有が完了しました！'
      expect(page).to have_css('.col-12.col-md-6.mb-4', count: 1)
      expect(PartnerShare.count).to eq(1) # 共有がDBに登録されたか確認
      shared_partner = PartnerShare.last
      expect(shared_partner.partner_id).to eq(partner.id)
      expect(shared_partner.user_id).to eq(user1.id)
    end

    it 'トークンが有効期限切れの場合' do
      expired_token = create_token(user1, nil, expiration_date: 1.day.ago)

      visit confirm_share_path(token: expired_token.token)
      expect(page).to have_content '無効なトークンです。'
      expect(PartnerShare.count).to eq(0) # 共有がDBに登録されていないことを確認
    end
  end
end
