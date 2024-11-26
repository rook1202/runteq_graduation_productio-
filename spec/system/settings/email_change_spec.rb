# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'メールアドレス変更ページ', type: :system do
  let(:user) { create(:user) }

  it 'ページが正しく表示される' do
    login_as(user)
    visit email_change_settings_path
    expect(page).to have_current_path(email_change_settings_path)
  end
end
