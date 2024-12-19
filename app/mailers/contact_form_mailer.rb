class ContactFormMailer < ApplicationMailer

    def contact_form(user, title, body)
        @user = user
        @body = body
    
        mail(
          to: "petnote0808@gmail.com", # 運営者のメールアドレス
          subject: title
        )
    end

end
