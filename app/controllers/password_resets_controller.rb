# frozen_string_literal: true

# パスワードリセット用コントローラー
class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      flash[:success] = 'パスワード再設定のリンクをメールで送信しました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'メールアドレスが見つかりません。'
      render :new
    end
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    return if @user.present?

    flash[:danger] = '無効なパスワードリセットリンクです。'
    redirect_to new_password_reset_path
  end

  def update
    @user = load_user_from_token
    return redirect_invalid_token if @user.blank?

    # 送信された値を確認
    # Rails.logger.debug "送信されたパスワード: #{params[:user][:password]}"
    # Rails.logger.debug "送信されたパスワード確認: #{params[:user][:password_confirmation]}"

    # 条件をチェックして出力
    # Rails.logger.debug "New Record: #{@user.new_record?}" # new_record?の結果を出力
    # Rails.logger.debug "Changes: #{@user.changes[:password]}" # changes[:crypted_password]の結果を出力

    # バリデーションチェックの内容を出力
    # check_validations(@user)

    if change_user_password
      flash[:success] = 'パスワードが変更されました。'
      redirect_to login_path
    else
      flash.now[:danger] = 'パスワードの変更ができませんでした。'
      render :edit
    end
  end

  private

  def load_user_from_token
    token = params[:id]
    User.load_from_reset_password_token(token)
  end

  def redirect_invalid_token
    flash[:danger] = '無効なパスワードリセットリンクです。'
    redirect_to new_password_reset_path
  end

  def change_user_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.change_password(params[:user][:password])
  end

  def blank_check
    # パスワードの空欄チェック
    return unless password.blank? || password_confirmation.blank?

    flash.now[:danger] = 'パスワードとパスワード確認を入力してください。'
    render :edit
    nil
  end

  def length_check
    return unless password.length < 6

    flash.now[:danger] = 'パスワードは6文字以上で入力してください。'
    render :edit
    nil
  end

  def equal_check
    return unless password != password_confirmation

    flash.now[:danger] = 'パスワードとパスワード確認が一致しません。'
    render :edit
    nil
  end

  # def check_validations(user)
  #   Rails.logger.debug '=== バリデーションチェック ==='
  #   user.class.validators.each do |validator|
  #     Rails.logger.debug "チェック内容: #{validator.attributes} - #{validator.options}"
  #     validator.attributes.each do |attribute|
  #       if user.errors[attribute].empty?
  #         Rails.logger.debug "  - #{attribute}: OK"
  #       else
  #         Rails.logger.debug "  - #{attribute}: NG (#{user.errors[attribute].join(', ')})"
  #       end
  #    end
  #   end
  #   Rails.logger.debug '==========================='
  # end
end
