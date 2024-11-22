# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'パートナー情報', type: :system do
  let(:user) { create(:user) }

  describe '新規作成（成功）' do
    before do
      login_as(user)
    end

    it 'パートナー新規作成に成功' do
      click_link 'パートナー追加'
      expect(page).to have_current_path(new_partner_path)

      expect do
        fill_in 'partner_name', with: 'テストネーム'
        fill_in 'partner_animal_type', with: 'わんこ'
        fill_in 'partner_breed', with: 'ダックスフント'
        fill_in 'partner_birthday', with: '2000-01-01'
        fill_in 'partner_weight', with: 'りんご一つ分'
        click_button '登録'
        expect(page).to have_content('登録が完了しました'), 'フラッシュメッセージが表示されていません'
      end.to change { Partner.count }.by(1)
      expect(page).to have_current_path(root_path), 'パートナー一覧画面に遷移していません'
      expect(page).to have_content('テストネーム') # パートナー名が表示されているか
      expect(page).to have_css('.col-12.col-md-6.mb-4', count: 1)
    end
  end
end

RSpec.describe 'パートナー情報', type: :system do
  let(:user) { create(:user) }
  describe '新規作成（失敗）' do
    before do
      login_as(user)
    end
    it 'パートナー新規作成に失敗' do
      visit '/partners/new'
      expect do
        fill_in 'partner_name', with: 'にゃんこネーム'
        click_button '登録'
      end.to change { User.count }.by(0)
      expect(page).to have_content('登録に失敗しました'), 'フラッシュメッセージが表示されていません'
      expect(page).to have_content('動物の種類 を入力してください'), 'エラーメッセージが表示されていません'
    end
  end
end
