# frozen_string_literal: true

RSpec.describe 'パートナーさんぽ情報', type: :system do
  let(:user) { create(:user) }

  describe '編集ページの表示' do
    let!(:partner_to_check) { create(:partner, owner: user) } # 詳細ページを確認する対象のパートナー

    before do
      login_as(user)
      click_on partner_to_check.name # パートナー名をクリックして詳細ページへ
      expect(page).to have_content(partner_to_check.name)
    end

    it 'さんぽ情報の編集' do
      find('#edit_walk').click
      expect(page).to have_current_path(edit_partner_walk_path(partner_to_check.id, partner_to_check.walks.first.id))

      fill_in 'walk_time', with: '1時間くらい'
      click_button '編集'
      expect(page).to have_content('1時間くらい') # 情報が更新されているか
    end
  end
end

RSpec.describe 'リマインダー情報', type: :system do
  let(:user) { create(:user) }

  describe '編集ページの表示' do
    let!(:partner_to_check) { create(:partner, owner: user) } # 詳細ページを確認する対象のパートナー

    before do
      login_as(user)
      click_on partner_to_check.name # パートナー名をクリックして詳細ページへ
      expect(page).to have_content(partner_to_check.name)
    end

    it 'リマインダーの時間の追加' do
      find('#edit_walk').click
      expect(page).to have_current_path(edit_partner_walk_path(partner_to_check.id, partner_to_check.walks.first.id))
      click_link '>> さんぽの時間追加'
      click_link '>> さんぽの時間追加'

      all('select').first.select '13:00'
      all('select').last.select '14:00'
      click_button '編集'

      expect(page).to have_content('13:00') # 時間が追加されているか
      expect(page).to have_content('14:00') # 時間が追加されているか
    end
  end
end
