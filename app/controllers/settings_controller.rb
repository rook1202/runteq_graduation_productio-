# frozen_string_literal: true

# 設定ページで行うアクション
class SettingsController < ApplicationController
  def show; end

  def name_change; end

  def email_change; end

  def update
    if current_user.update(user_params)
      flash[:success] = '変更が完了しました'
      redirect_to root_path
    else
      flash.now[:danger] = '変更が失敗しました'
      render :name_change, status: :unprocessable_entity
    end
  end
end

private

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end
