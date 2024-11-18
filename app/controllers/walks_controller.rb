# frozen_string_literal: true

# ペットのさんぽについての情報を管理するコントローラーです。
class WalksController < ApplicationController
  before_action :set_partner, only: %i[edit update add_remainder_field]
  before_action :set_walk, only: %i[edit update]

  def edit
    @walk.remainders.build if @walk.remainders.blank?
  end

  def update
    remainder_blank_check

    if @walk.update(walk_params)
      flash[:success] = 'さんぽの情報が更新されました。'
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

  def set_walk
    @walk = @partner.walks.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, 'walk not found' if @walk.nil?
  end

  def walk_params
    params.require(:walk).permit(
      :time, :note,
      remainders_attributes: %i[id time notification_status partner_id _destroy]
    )
  end

  def remainder_blank_check
    # 空のtimeを持つremainderを除外する
    filtered_remainders = params[:walk][:remainders_attributes].reject do |_, r|
      r[:time].blank?
    end
    # フィルタリングしたremaindersを再構築
    params[:walk][:remainders_attributes] = filtered_remainders
  end
end
