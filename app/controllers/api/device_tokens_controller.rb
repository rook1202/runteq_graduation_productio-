class Api::DeviceTokensController < ApplicationController
    protect_from_forgery with: :null_session

    def create
      device_token = DeviceToken.find_or_initialize_by(token: params[:token])
      device_token.user = current_user # 適切な関連付け
      if device_token.save
        render json: { status: 'success' }, status: :ok
      else
        render json: { status: 'error', errors: device_token.errors.full_messages }, status: :unprocessable_entity
      end
    end
end
