# frozen_string_literal: true

# パスワードリセット用コントローラー
class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.deliver_reset_password_instructions!
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

    if change_user_password
      flash[:success] = 'パスワードが変更されました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'パスワードの変更ができませんでした。'
      render :edit
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
end
