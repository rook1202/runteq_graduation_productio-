# frozen_string_literal: true

module CapybaraCookieHelper
  def get_rack_cookie(cookie_name)
    browser = page.driver.browser
    browser.manage.all_cookies.find { |c| c[:name] == cookie_name }&.fetch(:value, nil)
  rescue Selenium::WebDriver::Error::NoSuchCookieError
    nil
  end
end
