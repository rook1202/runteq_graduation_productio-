# frozen_string_literal: true

# ユーザーのログインに関するコントローラーです。
class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:success] = 'ログインしました'
      redirect_to root_path
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:danger] = 'ログアウトしました'
    redirect_to login_path, status: :see_other
  end
end
