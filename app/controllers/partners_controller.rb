# frozen_string_literal: true

# ペットについての基本情報を管理するコントローラーです。
class PartnersController < ApplicationController
  before_action :set_partner, only: %i[edit update destroy remove_image]

  def index
    @partners = current_user.partners_with_shared
    @show_tutorial = current_user.showed_tutorial
  end

  def complete_tutorial
    current_user.update(showed_tutorial: true)
    head :ok
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    @partner.owner_id = current_user.id # ここでログインユーザーのIDを設定
    if @partner.save
      flash[:success] = '登録が完了しました'
      redirect_to root_path
    else
      flash.now[:danger] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  # これ以上分けるとは何を渡しているかわからなくなるのでrubocopから除外
  def show
    @partner = Partner.find(params[:id])
    unless user_has_access_to_partner?
      redirect_to partners_path, alert: 'このパートナー情報を表示する権限がありません。'
      return
    end
    foods_walk_medications_set
    @notification_enabled = DeviceToken.exists?(user_id: current_user.id)

    set_shared_users
  end

  def edit; end

  def update
    if @partner.update(partner_params)
      flash[:success] = '更新が完了しました'
      redirect_to partner_path
    else
      flash.now[:danger] = '更新が失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @partner.destroy!
    flash[:success] = 'パートナー情報を削除しました'
    redirect_to root_path, status: :see_other
  end

  def remove_image
    @image = @partner.image
    @image.purge # 画像を削除

    respond_to do |format|
      format.html do
        redirect_to edit_partner_path(@partner),
                    notice: '画像が削除されました'
      end
      format.js # JavaScriptのリクエストに対応
    end
  end

  def create_token
    partner = params[:id] ? set_partner : nil
    host_url = root_url
    result = ShareService.new(host_url, current_user, partner).create_share

    respond_to do |format|
      if result
        format.json { render_success_response(result) }
      else
        format.turbo_stream { render_error_response }
      end
    end
  end

  def remove_share
    @partner = Partner.find(params[:id])
    unless user_has_access_to_partner?
      redirect_to partners_path, alert: 'このパートナー情報を表示する権限がありません。'
      return
    end

    @user_ids = params[:user_ids]

    if @partner.owner_id == current_user.id
      if @user_ids.blank?
        redirect_to partner_path(@partner), alert: '共有を解除する相手を選択してください。'
        return
      end
      remove_share_from_my_partner
    else
      remove_share_from_shared_partner
    end
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :animal_type, :breed, :gender, :birthday, :weight, :image)
  end

  def set_partner
    @partner = current_user.partners.find(params[:id])
  end

  def set_foods
    @foods, @food_remainders = set_resources('food', @partner)
  end

  def set_walk
    @walk = @partner.walks.first
    @walk_remainders = @partner.remainders.where(activity_type: 'Walk')
  end

  def set_medications
    @medications, @medication_remainders = set_resources('medication', @partner)
  end

  def foods_walk_medications_set
    set_foods
    set_walk
    set_medications
  end

  def render_success_response(result)
    render json: {
      success: true,
      share_url: result[:share_url],
      share_text: result[:share_text],
      qr_code_svg: result[:qr_code_svg]
    }, status: :ok
  end

  def render_error_response
    render turbo_stream: turbo_stream.replace(
      'flash-messages',
      partial: 'shared/error_message',
      locals: { message: 'トークン作成失敗' }
    )
  end

  def user_has_access_to_partner?
    # ログインユーザーがパートナーのオーナーか
    return true if @partner.owner_id == current_user.id

    # partner_shares テーブルに共有されているか
    PartnerShare.exists?(partner_id: @partner.id, shared_by: current_user.id)
  end

  def remove_share_from_my_partner
    shares = PartnerShare.where(partner_id: @partner.id, user_id: current_user.id, shared_by: @user_ids)
    if shares.destroy_all.any?
      redirect_to partner_path(@partner), notice: '選択した相手との共有を解除しました。'
    else
      redirect_to partner_path(@partner), alert: '解除対象がありませんでした。'
    end
  end

  def remove_share_from_shared_partner
    shares = PartnerShare.where(partner_id: @partner.id, shared_by: current_user.id)
    if shares.destroy_all.any?
      redirect_to root_path, notice: '共有を解除しました。'
    else
      redirect_to partner_path(@partner), alert: '解除対象がありませんでした。'
    end
  end

  def set_shared_users
    @shared_users = if @partner.owner_id == current_user.id
                      User.where(id: PartnerShare.where(partner_id: @partner.id,
                                                        user_id: current_user.id).select(:shared_by))
                    else
                      []
                    end
  end
end
