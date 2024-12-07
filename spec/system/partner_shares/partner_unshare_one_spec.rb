# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '共有解除（個別）', type: :system do
  let(:user1) { create(:user) }
  let(:user2) { create(:user, :other_user) }
  let!(:partner1) { create(:partner, owner: user1) }
  let!(:partner2) { create(:partner, owner: user2) }

  before do
    create_shared(partner1, user1, user2)
    create_shared(partner2, user2, user1)
  end

  describe 'パートナーの個別共有解除' do
    before do
      login_as(user1)
    end

    it '他ユーザーから共有されたパートナー1件を解除' do
      visit partner_path(partner2) # トークン発行画面
      click_button '共有解除'
      expect(page).to have_content('この共有を解除しますか？'), 'モーダルが表示されていません。'
      click_button '解除する'
      expect(page).to have_content('共有を解除しました。')

      # user2からuser1への共有が解除されたことを確認
      expect(PartnerShare.where(partner_id: partner2.id, shared_by: user1.id)).to be_empty
    end

    it '他ユーザーに共有した自分のパートナー1件を解除' do
      visit partner_path(partner1) # トークン発行画面
      click_button '共有解除'
      expect(page).to have_content('解除する共有相手を選択してください。'), 'モーダルが表示されていません。'
      choose 'てすと2'
      click_button '解除する'
      expect(page).to have_content '選択した相手との共有を解除しました。'

      # user1からuser2への共有が解除されたことを確認
      expect(PartnerShare.where(partner_id: partner1.id, shared_by: user2.id)).to be_empty
    end
  end
end
