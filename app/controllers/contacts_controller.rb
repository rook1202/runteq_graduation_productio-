class ContactsController < ApplicationController
  def new
    @default_title = "お問い合わせ" # タイトルの初期値
  end
    
  def create
    user = current_user
    title = params[:title].presence || "お問い合わせ" # タイトルが空の場合のデフォルト値
    body = params[:body]

    if title.blank? && body.blank?
        # タイトルと内容が両方空の場合のエラーメッセージ
        flash[:danger] = "内容を入力してください。"
        redirect_to new_contact_path and return
    end
    
    # メール送信
    ContactFormMailer.contact_form(user, title, body).deliver_now
    flash[:success] = "お問い合わせが送信されました！"
    redirect_to new_contact_path
  end
end
