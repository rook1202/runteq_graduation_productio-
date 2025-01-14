# frozen_string_literal: true

# メール設定
class ApplicationMailer < ActionMailer::Base

  default from: 'petnote0808@gmail.com'
  layout 'mailer'

end
