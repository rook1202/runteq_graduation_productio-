# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContactFormMailer, type: :mailer do
  describe 'お問い合わせ' do
    let(:user) { create(:user) }
    let(:title) { 'お問い合わせ件名' }
    let(:body) { 'お問い合わせ内容です！' }

    it 'お問い合わせが送信できるか' do
      expect do
        ContactFormMailer.contact_form(user, title, body).deliver_now
      end.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it '正しい内容がメールに含まれているか' do
      email = ContactFormMailer.contact_form(user, title, body).deliver_now

      expect(email.to).to eq(['petnote0808@gmail.com']) # 管理者のメールアドレス
      expect(email.subject).to eq('お問い合わせ件名')
      expect(email.body.to_s).to include('お問い合わせ内容です！')
      expect(email.body.to_s).to include('てすと') # ユーザー名を確認
      expect(email.body.to_s).to include('test@example.com') # ユーザーのメールアドレスを確認
    end
  end
end
