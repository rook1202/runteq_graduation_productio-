# frozen_string_literal: true

# メールアドレス変更のメールの送信設定
class EmailChangeMailer < ApplicationMailer
  def email_change_verification(user)
    @user = user
    mail(to: @user.new_email, subject: 'メールアドレス変更確認')
  end
end
