# frozen_string_literal: true

# メール設定
class ApplicationMailer < ActionMailer::Base
  before_action :force_recipient_in_production

  default from: 'petnote0808@gmail.com'
  layout 'mailer'

  private

  def force_recipient_in_production
    return unless Rails.env.production?

    mail(to: 'petnote0808@gmail.com')
  end
end
