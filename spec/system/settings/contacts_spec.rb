# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'お問い合わせフォーム', type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user)
    visit new_contact_path
  end

  it 'お問い合わせが送信できる' do
    expect(page).to have_current_path(new_contact_path), 'ページが表示されていません。'
    fill_in 'body', with: 'お問い合わせの内容を記述する！'
    click_button '送信'
    expect(page).to have_content('お問い合わせが送信されました！'), 'フラッシュメッセージが表示されていません'
  end
end
