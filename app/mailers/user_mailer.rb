# frozen_string_literal: true

# メールの送信設定
class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = user
    @reset_link = edit_password_reset_url(token: @user.reset_password_token)
    mail(to: @user.email, subject: 'パスワードリセットのご案内')
  end
end
