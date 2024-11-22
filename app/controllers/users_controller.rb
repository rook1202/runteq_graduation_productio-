# frozen_string_literal: true

# ユーザーの新規登録に関するコントローラーです。
class UsersController < ApplicationController
  skip_before_action :require_login

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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
