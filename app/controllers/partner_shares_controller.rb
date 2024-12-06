# frozen_string_literal: true

# Partner共有のための認証・保存アクション
class PartnerSharesController < ApplicationController
  def confirm
    token = Token.authenticate(params[:token])
    redirect_to root_path, alert: '無効なトークンです。' and return if token.nil?

    if token.partner_id.nil?
      process_bulk_share(token)
    else
      process_individual_share(token)
    end
  end

  def mutual_unshare
    user_id = params[:user_id]
    shared_by_me = PartnerShare.remove_shared_by_me(current_user.id, user_id)
    shared_with_me = PartnerShare.remove_shared_with_me(current_user.id, user_id)
    user_name = User.find(user_id).name

    # 削除件数を確認
    if shared_by_me.empty? && shared_with_me.empty?
      redirect_to settings_path, alert: "#{user_name}との相互共有はありません。"
    else
      redirect_to settings_path, notice: "#{user_name}との相互共有を解除しました。"
    end
  end

  def other_partner_unshare
    user_id = params[:user_id]
    shared_by_me = PartnerShare.remove_shared_by_me(current_user.id, user_id)
    user_name = User.find(user_id).name

    if shared_by_me.empty?
      redirect_to settings_path, alert: "#{user_name}から共有されたパートナーはありません。"
    else
      redirect_to settings_path, notice: "#{user_name}から共有されたパートナーを解除しました。"
    end
  end

  def my_partner_unshare
    user_id = params[:user_id]
    shared_with_me = PartnerShare.remove_shared_with_me(current_user.id, user_id)
    user_name = User.find(user_id).name

    if shared_with_me.empty?
      redirect_to settings_path, alert: "#{user_name}へのパートナー共有はありません。"
    else
      redirect_to settings_path, notice: "#{user_name}へのパートナー共有を解除しました。"
    end
  end

  private

  def process_bulk_share(token)
    success_count = PartnerShare.process_bulk_share(token, current_user.id)
    if success_count.positive?
      redirect_to partners_path, notice: "#{success_count}件の共有が成功しました！"
    else
      redirect_to root_path, alert: '一括共有中にエラーが発生しました。'
    end
  end

  def process_individual_share(token)
    if PartnerShare.process_individual_share(token, current_user.id)
      redirect_to partners_path, notice: '共有が成功しました！'
    else
      redirect_to root_path, alert: '共有処理中にエラーが発生しました。'
    end
  end
end
