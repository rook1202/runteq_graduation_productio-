# frozen_string_literal: true

# メールアドレス変更に関わるコントローラー
class EmailChangesController < ApplicationController
  def new
    @user = current_user
  end

  def create
    @user = current_user
    user_set

    if @user.save
      EmailChangeMailer.email_change_verification(@user).deliver_now
      flash[:success] = '確認メールを送信しました。'
      redirect_to settings_path
    else
      flash[:danger] = 'メールアドレス変更リクエストが失敗しました。'
      render :new
    end
  end

  def confirm
    # トークンを検証
    @user = User.find_by(id: params[:id], email_change_token: params[:token])

    if @user && @user.email_change_token_expires_at > Time.current
      # メールアドレスを更新
      user_email_update
      email_save_check
    else
      flash[:danger] = 'メールアドレス変更リンクが無効または期限切れです。'
    end
    redirect_to root_path
  end

  def update; end

  private

  def user_set
    @user.new_email = params[:new_email]
    @user.email_change_token = SecureRandom.urlsafe_base64
    @user.email_change_token_expires_at = 2.hours.from_now
    @user.email_change_requested_at = Time.current
  end

  def user_email_update
    @user.email = @user.new_email
    @user.new_email = nil
    @user.email_change_token = nil
    @user.email_change_token_expires_at = nil
  end

  def email_save_check
    if @user.save
      flash[:success] = 'メールアドレスの変更が完了しました。'
    else
      flash[:danger] = 'メールアドレス変更に失敗しました。'
    end
  end
end
