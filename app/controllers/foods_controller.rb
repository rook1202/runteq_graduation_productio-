# frozen_string_literal: true

# ペットのごはんについての情報を管理するコントローラーです。
class FoodsController < ApplicationController
  before_action :set_partner, only: %i[edit update remove_image]
  before_action :set_food, only: %i[edit update remove_image]

  def edit
    # remaindersがnilまたは空の場合、新しいインスタンスを追加
    @food.remainders.build if @food.remainders.blank?
  end

  def update
    remainder_blank_check

    if @food.update(food_params)
      flash[:success] = 'ごはんの情報が更新されました。'
      redirect_to partner_path(@partner)
    else
      flash.now[:danger] = '更新が失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def remove_image
    @image = @food.image
    @image.purge # 画像を削除

    respond_to do |format|
      format.html { redirect_to edit_partner_food_path(@partner, @food), notice: '画像が削除されました' }
      format.js # JavaScriptのリクエストに対応
    end
  end

  private

  def set_partner
    @partner = current_user.partners.find(params[:partner_id])
  end

  def set_food
    @food = @partner.foods.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, 'Food not found' if @food.nil?
  end

  def food_params
    permitted_params = params.require(:food).permit(
      :manufacturer, :category, :amount, :place, :note, :image,
      remainders_attributes: %i[id time notification_status partner_id _destroy]
    )
    Rails.logger.debug "Permitted Params: #{permitted_params.inspect}" # デバッグ用
    permitted_params
  end

  def remainder_blank_check
    # 空のtimeを持つremainderを除外する
    filtered_remainders = params[:food][:remainders_attributes].reject do |_, r|
      r[:time].blank?
    end
    # フィルタリングしたremaindersを再構築
    params[:food][:remainders_attributes] = filtered_remainders
  end
end
