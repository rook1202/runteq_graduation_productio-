
# パスワードリセット用コントローラー
class PasswordResetsController < ApplicationController
  skip_before_action :require_login
  
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      flash[:success] = 'パスワードリセットのリンクをメールで送信しました。'
      redirect_to root_path
    else
      flash.now[:danger] = 'メールアドレスが見つかりません。'
      render :new
    end
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    if @user.blank?
      flash[:danger] = '無効なパスワードリセットリンクです。'
      redirect_to new_password_reset_path
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)
    if @user.blank?
      flash[:danger] = '無効なパスワードリセットリンクです。'
      redirect_to new_password_reset_path
      return
    end

      # Sorceryのパスワード変更メソッドの前に直接属性を設定
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]

      # バリデーションチェックの内容を出力
      check_validations(@user)
      
    if @user.valid? # バリデーションを手動でチェック
      if @user.change_password(params[:user][:password])
        flash[:success] = 'パスワードが変更されました。'
        redirect_to login_path
      else
         puts "change_passwordでのエラー: #{@user.errors.full_messages}"
        flash.now[:danger] = 'パスワードの変更ができませんでした。'
        render :edit
      end
    end
  end

  private

  def blank_check
    # パスワードの空欄チェック
    if password.blank? || password_confirmation.blank?
      flash.now[:danger] = 'パスワードとパスワード確認を入力してください。'
      render :edit
      return
    end
  end

  def length_check
    if password.length < 6
      flash.now[:danger] = 'パスワードは6文字以上で入力してください。'
      render :edit
      return
    end
  end

  def equal_check
    if password != password_confirmation
      flash.now[:danger] = 'パスワードとパスワード確認が一致しません。'
      render :edit
      return
    end
  end

  def check_validations(user)
    puts "=== バリデーションチェック ==="
    user.class.validators.each do |validator|
      puts "チェック内容: #{validator.attributes} - #{validator.options}"
      validator.attributes.each do |attribute|
        if user.errors[attribute].empty?
          puts "  - #{attribute}: OK"
        else
          puts "  - #{attribute}: NG (#{user.errors[attribute].join(', ')})"
        end
      end
    end
    puts "==========================="
  end

end
