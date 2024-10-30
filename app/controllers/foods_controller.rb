class FoodsController < ApplicationController
  before_action :set_partner, only: [:edit, :update, :add_remainder_field]
  before_action :set_food, only: [:edit, :update]

  def edit
    # remaindersがnilまたは空の場合、新しいインスタンスを追加
    @food.remainders.build if @food.remainders.blank?
  end

  def update
      # 空のtimeを持つremainderを除外する
      filtered_remainders = params[:food][:remainders_attributes].reject do |_, r|
        r[:time].blank?
      end
      # フィルタリングしたremaindersを再構築
      params[:food][:remainders_attributes] = filtered_remainders

    if @food.update(food_params)
      flash[:success] = 'ごはんの情報が更新されました。'
      redirect_to partner_path(@partner)
    else
      flash.now[:danger] = '更新が失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_partner
    @partner = current_user.partners.find(params[:partner_id])
  end

  def set_food
    @food = @partner.foods.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Food not found" if @food.nil?
  end

  def food_params
    permitted_params = params.require(:food).permit(
    :manufacturer, :category, :amount, :place, :note,
    remainders_attributes: [:id, :time, :notification_status, :partner_id, :_destroy]
  )
  puts "Permitted Params: #{permitted_params.inspect}" # デバッグ用
  permitted_params
  end

end
