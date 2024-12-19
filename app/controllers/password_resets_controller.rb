# frozen_string_literal: true

# パスワードリセット用コントローラー
class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :auto_login_with_remember_me

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      UserMailer.reset_password_email(@user).deliver_now
      logout
      flash[:success] = 'パスワード再設定のリンクをメールで送信しました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'メールアドレスが見つかりません。'
      render :new
    end
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    return if @user.present?

    flash[:danger] = '無効なパスワードリセットリンクです。'
    redirect_to new_password_reset_path
  end

  def update
    @user = load_user_from_token
    return redirect_invalid_token if @user.blank?

    params[:user][:password]
    params[:user][:password_confirmation]

    if handle_password_change
      redirect_to login_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def load_user_from_token
    token = params[:id]
    User.load_from_reset_password_token(token)
  end

  def redirect_invalid_token
    flash[:danger] = '無効なパスワードリセットリンクです。'
    redirect_to new_password_reset_path
  end

  def change_user_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.change_password(params[:user][:password])
  end

  def logout
    # セッションをクリアしてログアウト処理を実行
    reset_session
  end

  def handle_password_change
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]

    return false unless validate_passwords(password, password_confirmation)

    if change_user_password
      flash[:success] = 'パスワードが変更されました。'
      true
    else
      flash.now[:danger] = 'パスワードの変更ができませんでした。'
      false
    end
  end

  def validate_passwords(password, password_confirmation)
    if password.blank? || password_confirmation.blank?
      flash.now[:danger] = 'パスワードとパスワード確認を入力してください。'
      return false
    elsif password.length < 6
      flash.now[:danger] = 'パスワードは6文字以上で入力してください。'
      return false
    elsif password != password_confirmation
      flash.now[:danger] = 'パスワードと確認用パスワードが一致しません。'
      return false
    end
    true
  end
end
