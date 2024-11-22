# frozen_string_literal: true

RSpec.describe 'パートナーおくすり情報', type: :system do
  let(:user) { create(:user) }

  describe '編集ページの表示' do
    let!(:partner_to_check) { create(:partner, owner: user) } # 詳細ページを確認する対象のパートナー

    before do
      login_as(user)
      click_on partner_to_check.name # パートナー名をクリックして詳細ページへ
      expect(page).to have_content(partner_to_check.name)
    end

    it 'おくすり情報の編集' do
      find('#edit_medication').click
      expect(page).to have_current_path(edit_partner_medication_path(partner_to_check.id,
                                                                     partner_to_check.medications.first.id))

      fill_in 'medication_clinic', with: 'なかよしクリニック'
      click_button '編集'

      expect(page).to have_content('なかよしクリニック') # 情報が更新されているか
    end
  end
end
