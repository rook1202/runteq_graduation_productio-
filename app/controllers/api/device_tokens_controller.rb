# frozen_string_literal: true

# OneSignalIDを取得したあとplayerIdとして保存するモジュール
module Api
  # OneSignalIDを取得したあとplayerIdとして保存するアクション
  class DeviceTokensController < ApplicationController
    def create
      @device_token = DeviceToken.find_or_initialize_by(player_id: params[:player_id])

      if @device_token.persisted? || @device_token.update(user_id: current_user.id)
        flash[:success] = '通知を有効にしました。'
      else
        flash[:error] = '通知を有効にできませんでした。'
      end
    end

    def destroy
      @device_token = DeviceToken.find_by(player_id: params[:id], user_id: current_user.id)

      if @device_token&.destroy
        flash[:success] = '通知を無効にしました。'
      else
        flash[:error] = '通知を無効にできませんでした。'
      end
    end
  end
end
