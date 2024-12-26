# frozen_string_literal: true

# ペットのごはんについての情報を管理するコントローラーです。
class FoodsController < ApplicationController
  before_action :set_partner, only: %i[create edit update remove_image destroy]
  before_action :set_food, only: %i[edit update remove_image]

  def create
    @food = Food.create_empty(@partner.id)
    @foods = Food.where(partner_id: @partner.id) # 全てのフードを取得

    if @food.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "foodTabContainer",
            partial: "foods/food_index",
            locals: { partner: @partner, foods: @foods, remainders: @partner.remainders.where(activity_type: 'Food') }
          )
        end
        format.html { redirect_to partner_path(@partner), notice: "新しい項目を追加しました。" }
      end
    else
      flash.now[:danger] = 'ごはんページの追加が失敗しました'
      redirect_to partner_path(partner)
    end
  end

  def edit
    # remaindersがnilまたは空の場合、新しいインスタンスを追加
    return if @food.remainders.present?

    @food.remainders.build
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

  def destroy
    @food = Food.find(params[:id])
    @foods = Food.where(partner_id: @partner.id)
  
    if destroy_count(@foods, @food, @partner)
      respond_to do |format|
        format.html { redirect_to partner_path(@partner) }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "foodTabContainer",
            partial: "foods/food_index",
            locals: { partner: @partner, foods: @foods, remainders: @partner.remainders.where(activity_type: 'Food') }
          )
        end
      end
    end
  end

  private

  def set_partner
    @partner = current_user.partners.find(params[:partner_id])
  end

  def set_food
    @food = @partner.foods.find_by(id: params[:id])
    return unless @food.nil?

    raise ActiveRecord::RecordNotFound,
          'Food not found'
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
    params[:food][:remainders_attributes] =
      filtered_remainders
  end

  def destroy_count(foods, food, partner)
    if foods.count > 1
      if food
        food.destroy
        return true
      else
        flash[:danger] = "削除対象が見つかりませんでした。"
        redirect_to partner_path(partner) and return
      end
    else
      flash[:danger] = "少なくとも1つは残す必要があります。"
      redirect_to partner_path(partner) and return
    end
  end
end
