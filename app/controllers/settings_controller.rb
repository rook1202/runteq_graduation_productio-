# frozen_string_literal: true

# 設定ページで行うアクション
class SettingsController < ApplicationController
  def show
    # 自分が共有しているユーザー
    users_shared_by_me = User.joins(:partner_shares)
                             .where(partner_shares: { shared_by: current_user.id })

    # 自分に共有しているユーザー
    users_shared_with_me = User.where(
      id: PartnerShare.where(user_id: current_user.id).select(:shared_by)
    )

    # 結合して重複を排除
    @shared_users = (users_shared_by_me + users_shared_with_me).uniq
  end

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
