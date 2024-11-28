# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailChangeMailer, type: :mailer do
  describe 'メールアドレス変更メール' do
    let(:user) do
      create(:user, email_change_token: 'example_token', email_change_token_expires_at: 2.hours.from_now,
                    new_email: 'change@example.com')
    end

    it 'メールアドレス変更メールの送信' do
      expect do
        EmailChangeMailer.email_change_verification(user).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it '正しいメールの内容が含まれているか' do
      email = EmailChangeMailer.email_change_verification(user).deliver_now

      # メールの基本情報を確認
      expect(email.to).to eq([user.new_email])
      expect(email.subject).to eq('メールアドレス変更確認')

      # メール本文にリンクが含まれているか確認
      mail_body = email.body.encoded
      expect(mail_body).to include('メールアドレスの変更を受付けました')
      expect(mail_body).to include('example_token')
    end
  end
end
