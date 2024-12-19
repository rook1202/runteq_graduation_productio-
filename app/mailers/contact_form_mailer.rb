# frozen_string_literal: true

# お問い合わせフォームから起動するmailer設定
class ContactFormMailer < ApplicationMailer
  def contact_form(user, title, body)
    @user = user
    @body = body

    mail(
      to: 'petnote0808@gmail.com', # 運営者のメールアドレス
      subject: title
    )
  end
end
