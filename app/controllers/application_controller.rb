# frozen_string_literal: true

# ApplicationControllerは、すべてのコントローラーの基本クラスです。
# 共通のロジックやフィルターを定義します。
class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    unless logged_in?
      flash[:success] = 'ログインしてください。'
      redirect_to login_path
    end
  end

  def set_resource(type, partner)
    resource = partner.public_send(type.pluralize).find_by(partner_id: params[:id])
    remainders = partner.remainders.where(activity_type: type.capitalize)

    unless resource
      redirect_to partner_path
      return nil
    end

    [resource, remainders]
  end
end
