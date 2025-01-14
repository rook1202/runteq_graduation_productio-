# frozen_string_literal: true

# ユーザーの新規登録に関するコントローラーです。
class UsersController < ApplicationController
  skip_before_action :require_login
  skip_before_action :auto_login_with_remember_me

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user) # Sorceryの自動ログインメソッドを呼び出し
      flash[:success] = 'ユーザー登録が完了しました'
      redirect_to root_path
    else
      Rails.logger.debug "User save failed: #{@user.errors.full_messages}"
      flash.now[:danger] = 'ユーザー登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def delete; end

  def destroy
    if current_user
      if current_user.destroy
        flash[:success] = 'アカウントを削除しました。'
        redirect_to login_path
      else
        flash[:danger] = 'アカウント削除に失敗しました。'
        redirect_to settings_path
      end
    else
      flash[:alert] = 'ログインが必要です。'
      redirect_to login_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
