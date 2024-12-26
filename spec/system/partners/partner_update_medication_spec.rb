# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パートナーおくすり情報', type: :system do
  let(:user) { create(:user) }
  let!(:partner_to_check) { create(:partner, owner: user) } # 詳細ページを確認する対象のパートナー

  describe '編集ページの表示' do
    before do
      login_as(user)
      click_on partner_to_check.name # パートナー名をクリックして詳細ページへ
      expect(page).to have_content(partner_to_check.name)
    end

    it 'おくすり情報の編集' do
      medication = partner_to_check.medications.first
      find("#edit_medication_#{medication.id}").click
      expect(page).to have_current_path(edit_partner_medication_path(partner_to_check.id, medication.id))

      fill_in 'medication_clinic', with: 'なかよしクリニック'
      click_button '編集'

      expect(page).to have_content('なかよしクリニック') # 情報が更新されているか
    end

    it 'おくすり情報の追加' do
      find('#add_medication').click
      expect(page).to have_content('おくすり 2') # 情報が追加されているか
      click_on('おくすり 2') # テキストでタブをクリック
      expect(page).to have_content('まだおくすりに関する登録はありません。')
    end

    it 'おくすり情報の削除' do
      find('#add_medication').click
      expect(page).to have_content('おくすり 2')
      find('#destroy_medication').click
      expect(page).to have_content('どれを削除しますか？')

      within('#deleteMedicationModal') do
        all('a', text: '削除').first.click # 一番上の削除ボタンをクリック
      end
      expect(page).to have_content('どれを削除しますか？')
      find('.btn-close[data-bs-dismiss="modal"]').click
      expect(page).not_to have_content('おくすり 2')
    end
  end
end
