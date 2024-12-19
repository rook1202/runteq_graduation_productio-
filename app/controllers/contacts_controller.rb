# frozen_string_literal: true

# お問い合わせフォームに入力された内容を運営へメール送信するアクション
class ContactsController < ApplicationController
  def new
    @default_title = 'お問い合わせ' # タイトルの初期値
  end

  def create
    user = current_user
    title = params[:title].presence
    body = params[:body]

    blank_check(title, body)

    # メール送信
    ContactFormMailer.contact_form(user, title, body).deliver_now
    flash[:success] = 'お問い合わせが送信されました！'
    redirect_to new_contact_path
  end

  private

  def blank_check(title, body)
    return unless title.blank? && body.blank?

    # タイトルと内容が両方空の場合のエラーメッセージ
    flash[:danger] = '内容を入力してください。'
    redirect_to new_contact_path and return
  end
end
