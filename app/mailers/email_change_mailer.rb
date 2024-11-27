# frozen_string_literal: true

# メールアドレス変更のメールの送信設定
class EmailChangeMailer < ApplicationMailer
  def email_change_verification(user)
    @user = user
    @url = Rails.application.routes.url_helpers.email_change_url(@user, token: @user.email_change_token) # URL を生成
    mail(to: @user.new_email, subject: 'メールアドレス変更確認')
  end
end
