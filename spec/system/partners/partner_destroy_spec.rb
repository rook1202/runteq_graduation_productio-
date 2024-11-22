# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パートナー情報', type: :system do
  let(:user) { create(:user) }

  describe 'パートナーの削除' do
    # 関連データも含めて2つのパートナーを作成
    let!(:partner_to_destroy) { create(:partner, owner: user) }
    before do
      login_as(user)
    end

    it 'パートナーが削除できる' do
      visit partner_path(partner_to_destroy.id)
      expect(page).to have_current_path(partner_path(partner_to_destroy.id))
      accept_confirm 'このページを削除しますか？' do
        find('#delete_partner').click
      end
      expect(page).to have_content('パートナー情報を削除しました'), 'フラッシュメッセージが表示されていません'
      expect(page).not_to have_content('パートナー名')
    end
  end
end
