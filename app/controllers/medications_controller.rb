# frozen_string_literal: true

# ペットのおくすりについての情報を管理するコントローラーです。
class MedicationsController < ApplicationController
  before_action :set_partner,
                only: %i[edit update remove_image]
  before_action :set_medication,
                only: %i[edit update remove_image]

  def edit
    return if @medication.remainders.present?

    @medication.remainders.build
  end

  def update
    remainder_blank_check
    add_image

    if @medication.update(medication_params.except(:images))
      flash[:success] = 'おくすりの情報が更新されました。'
      redirect_to partner_path(@partner)
    else
      flash.now[:danger] = '更新が失敗しました'
      render :edit, status: :unprocessable_entity
    end
  end

  def remove_image
    image = @medication.images.find(params[:image_id])
    image.purge # 画像を削除

    Rails.logger.debug "画像削除: #{image.id}"
    @image_id = image.id # JavaScriptに渡すためのインスタンス変数

    respond_to do |format|
      format.html { redirect_to edit_partner_medication_path(@partner, @medication), notice: '画像が削除されました' }
      format.js # JavaScriptのリクエストに対応
    end
  end

  private

  def set_partner
    @partner = current_user.partners.find(params[:partner_id])
  end

  def set_medication
    @medication = @partner.medications.find_by(id: params[:id])
    return unless @medication.nil?

    raise ActiveRecord::RecordNotFound,
          'Medication not found'
  end

  def medication_params
    params.require(:medication).permit(
      :name, :amount, :place, :clinic, :note, images: [],
                                              remainders_attributes: %i[id time notification_status partner_id _destroy]
    )
  end

  def remainder_blank_check
    # 空のtimeを持つremainderを除外する
    filtered_remainders = params[:medication][:remainders_attributes].reject do |_, r|
      r[:time].blank?
    end
    # フィルタリングしたremaindersを再構築
    params[:medication][:remainders_attributes] =
      filtered_remainders
  end

  def add_image
    # 既存の画像があるとき新規画像として追加
    @medication = Medication.find(params[:id])
    return unless params[:medication][:images]

    params[:medication][:images].each do |image|
      @medication.images.attach(image)
    end
  end
end
