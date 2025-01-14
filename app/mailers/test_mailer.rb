# frozen_string_literal: true

# 本番環境テスト用の送信メール
class TestMailer < ApplicationMailer
  layout false # レイアウトを無効化

  def test_email
    mail(
      to: 'petnote0808@gmail.com',
      subject: 'テストメール',
      body: 'メール送信テストです。' # 本文を直接指定
    )
  end
end
