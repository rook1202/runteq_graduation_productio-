# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'パスワード変更メール' do
    let(:user) { create(:user, reset_password_token: 'example_token') }

    it 'パスワード変更メールの送信' do
      expect do
        UserMailer.reset_password_email(user).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it '正しいメールの内容が含まれているか' do
      email = UserMailer.reset_password_email(user).deliver_now
      expect(email.to).to eq([user.email])
      expect(email.subject).to eq('パスワードリセットのご案内')
      expect(email.body.encoded).to include(edit_password_reset_url('example_token'))
    end
  end
end
