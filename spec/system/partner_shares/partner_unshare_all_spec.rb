# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '共有解除（一括）', type: :system do
  let(:user1) { create(:user) }
  let(:user2) { create(:user, :other_user) }
  let!(:partners1) { create_list(:partner, 2, owner: user1) }
  let!(:partners2) { create_list(:partner, 2, owner: user2) }

  before do
    create_shared_partners(user1, partners1, user2, partners2)
  end

  describe 'パートナーの一括共有解除' do
    before do
      login_as(user1)
    end

    it '他ユーザーとの相互共有を解除' do
      visit settings_path # トークン発行画面
      click_button '共有解除'
      expect(page).to have_content('てすと2との共有を解除'), 'モーダルが表示されていません。'
      click_button '相互共有を解除'
      expect(page).to have_content 'てすと2との相互共有を解除しました。'

      # 両方向の共有が解除されたことを確認
      expect(PartnerShare.where(user_id: user2.id, shared_by: user1.id)).to be_empty
      expect(PartnerShare.where(user_id: user1.id, shared_by: user2.id)).to be_empty
    end

    it '他ユーザーから共有されたすべてのパートナーを解除' do
      visit settings_path # トークン発行画面
      click_button '共有解除'
      expect(page).to have_content('てすと2との共有を解除'), 'モーダルが表示されていません。'
      click_button '相手から共有されたすべてのパートナーの共有解除'
      expect(page).to have_content('てすと2から共有されたパートナーを解除しました。')

      # user2からuser1への共有が解除されたことを確認
      expect(PartnerShare.where(user_id: user2.id, shared_by: user1.id)).to be_empty
    end

    it '他ユーザーに共有したすべての自分のパートナーを解除' do
      visit settings_path # トークン発行画面
      click_button '共有解除'
      expect(page).to have_content('てすと2との共有を解除'), 'モーダルが表示されていません。'
      click_button '相手へ共有した自分のすべてのパートナーの共有解除'
      expect(page).to have_content 'てすと2へのパートナー共有を解除しました。'

      # user1からuser2への共有が解除されたことを確認
      expect(PartnerShare.where(user_id: user1.id, shared_by: user2.id)).to be_empty
    end
  end
end
