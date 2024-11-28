# frozen_string_literal: true

module SystemHelpers
  def login_as(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: '12345678'
    click_button 'ログイン'
    expect(page).to have_current_path(root_path) # ログイン確認
  end
end
