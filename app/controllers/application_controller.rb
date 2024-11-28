# frozen_string_literal: true

# ApplicationControllerは、すべてのコントローラーの基本クラスです。
# 共通のロジックやフィルターを定義します。
class ApplicationController < ActionController::Base
  before_action :require_login
  before_action :auto_login_with_remember_me

  private

  def auto_login_with_remember_me
    return if current_user # 既にログイン中なら何もしない

    # Remember Me のクッキーがあれば、セッションを復元
    session = fetch_valid_session
    auto_login(session.user) if session
  end

  def fetch_valid_session
    return unless cookies.signed[:session_id].present? && cookies[:remember_token].present?

    session = Session.find_by(id: cookies.signed[:session_id])
    return if session.nil? || session.expired?
    return unless session.valid_token?(cookies[:remember_token])

    session
  end

  def require_login
    return if logged_in?

    flash[:success] = 'ログインしてください。'
    redirect_to login_path
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
