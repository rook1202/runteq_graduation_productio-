# frozen_string_literal: true

# メールの送信設定
class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = user
    mail(to: @user.email, subject: 'パスワードリセットのご案内')
  end
end
