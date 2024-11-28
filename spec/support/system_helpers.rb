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

module CapybaraCookieHelper
  def get_rack_cookie(cookie_name)
    browser = page.driver.browser
    browser.manage.all_cookies.find { |c| c[:name] == cookie_name }&.fetch(:value, nil)
  rescue Selenium::WebDriver::Error::NoSuchCookieError
    nil
  end
end
