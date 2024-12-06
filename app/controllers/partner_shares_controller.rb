class PartnerSharesController < ApplicationController
    def confirm
        # トークン認証
        token = Token.authenticate(params[:token])
    
        if token.nil?
          redirect_to root_path, alert: "無効なトークンです。" and return
        end
    
        # 一括共有か個別共有かを確認
        if token.partner_id.nil?
          # 一括共有：user_idに関連する全てのpartner_idを取得して保存
          partners = Partner.where(owner_id: token.user_id)

          partner_shares = partners.map do |partner|
            {
              partner_id: partner.id,
              user_id: token.user_id,
              shared_by: current_user.id,
              created_at: Time.current,
              updated_at: Time.current
            }
          end
      
          # バルクインサート
          saved_records = PartnerShare.insert_all(partner_shares)

          if partner_shares.size > 0
            redirect_to partners_path, notice: "#{partner_shares.size}件の共有が成功しました！"
          else
            redirect_to root_path, alert: "一括共有中にエラーが発生しました。"
          end
        else
          # 個別共有：token.partner_idが指定されている場合
          partner_share = PartnerShare.new(
            partner_id: token.partner_id,
            user_id: token.user_id,
            shared_by: current_user.id
          )
    
          if partner_share.save
            redirect_to partners_path, notice: "共有が成功しました！"
          else
            redirect_to root_path, alert: "共有処理中にエラーが発生しました。"
          end
        end
    end
    
    def mutual_unshare
        user_id = params[:user_id]
        shared_by_me = PartnerShare.where(shared_by: current_user.id, user_id: user_id).destroy_all
        shared_with_me = PartnerShare.where(shared_by: user_id, user_id: current_user.id).destroy_all
      
        # 削除件数を確認
        if shared_by_me.empty? && shared_with_me.empty?
            redirect_to settings_path, alert: "#{User.find(user_id).name}との相互共有はありません。"
        else
            redirect_to settings_path, notice: "#{User.find(user_id).name}との相互共有を解除しました。"
        end
    end

    def other_partner_unshare
        user_id = params[:user_id]
        shared_by_me = PartnerShare.where(shared_by: current_user.id, user_id: user_id).destroy_all
      
        if shared_by_me.empty?
          redirect_to settings_path, alert: "#{User.find(user_id).name}から共有されたパートナーはありません。"
        else
          redirect_to settings_path, notice: "#{User.find(user_id).name}から共有されたパートナーを解除しました。"
        end
    end

    def my_partner_unshare
        user_id = params[:user_id]
        shared_with_me = PartnerShare.where(shared_by: user_id, user_id: current_user.id).destroy_all
      
        if shared_with_me.empty?
          redirect_to settings_path, alert: "#{User.find(user_id).name}へのパートナー共有はありません。"
        else
          redirect_to settings_path, notice: "#{User.find(user_id).name}へのパートナー共有を解除しました。"
        end
    end
end
