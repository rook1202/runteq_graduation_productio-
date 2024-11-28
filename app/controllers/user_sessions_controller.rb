# frozen_string_literal: true

# ユーザーのログインに関するコントローラーです。
class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :auto_login_with_remember_me, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      handle_successful_login
    else
      handle_failed_login
    end
  end

  def destroy
    clear_session # クッキーがあれば削除処理を実行

    logout
    flash[:danger] = 'ログアウトしました'
    redirect_to login_path, status: :see_other
  end

  private

  def handle_successful_login
    ip_address = request.remote_ip
    session_retention(ip_address) if params[:remember_me] == '1'

    flash[:success] = 'ログインしました'
    redirect_to root_path
  end

  def handle_failed_login
    flash.now[:danger] = 'ログインに失敗しました'
    render :new, status: :unprocessable_entity
  end

  def session_retention(ip_address)
    session_data = Session.create_session_for(@user, ip_address)
    cookies.permanent.signed[:session_id] = session_data[:session].id
    cookies.permanent[:remember_token] = session_data[:token]
  end

  def clear_session
    if (session_id = cookies.signed[:session_id])
      session = Session.find_by(id: session_id)
      session&.destroy
      cookies.delete(:session_id)
      cookies.delete(:remember_token)
    end
  end
end
