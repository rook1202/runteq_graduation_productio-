# frozen_string_literal: true

# ユーザーのSNSログイン（新規登録）に関するコントローラーです。
class SnsLoginsController < ApplicationController
  skip_before_action :require_login
  skip_before_action :auto_login_with_remember_me

  def create
    user_info = request.env['omniauth.auth']
    user = find_or_create_user(user_info)
    login_user(user)
    redirect_to root_path
  end

  private

  def find_or_create_user(user_info)
    # 1. プロバイダーとUIDで既存ユーザーを検索
    user = find_user_by_provider_and_uid(user_info)
    return user if user

    # 2. メールアドレスで既存ユーザーを検索（別プロバイダーでのログイン）
    user = find_user_by_email(user_info)
    if user
      attach_provider_to_existing_user(user, user_info)
      return user
    end

    # 3. 新規ユーザーを登録
    register_new_user(user_info)
  end

  def find_user_by_provider_and_uid(user_info)
    User.find_by(provider: user_info['provider'], uid: user_info['uid'])
  end

  def find_user_by_email(user_info)
    User.find_by(email: user_info['info']['email'])
  end

  def attach_provider_to_existing_user(user, user_info)
    # プロバイダー情報を更新
    user.update(provider: user_info['provider'], uid: user_info['uid'])
  end

  def register_new_user(user_info)
    user = build_new_user(user_info)
    save_user_or_handle_error(user)
  end

  def build_new_user(user_info)
    password = SecureRandom.hex(16)
    User.new(
      email: user_info['info']['email'],
      name: user_info['info']['name'],
      provider: user_info['provider'],
      uid: user_info['uid'],
      password: password,
      password_confirmation: password
    )
  end

  def save_user_or_handle_error(user)
    unless user.save
      log_and_flash_user_save_error(user)
      redirect_to login_path and return
    end
    user
  end

  def log_and_flash_user_save_error(user)
    Rails.logger.error "User save failed: #{user.errors.full_messages}"
    flash[:danger] = 'ユーザー登録に失敗しました'
  end

  def login_user(user)
    Rails.logger.debug "OmniAuth User Info: #{request.env['omniauth.auth'].inspect}"
    auto_login(user)
    flash[:success] = 'ログインしました'
  end
end
