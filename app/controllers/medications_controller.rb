# frozen_string_literal: true

# ペットのおくすりについての情報を管理するコントローラーです。
class MedicationsController < ApplicationController
  before_action :set_partner,
                only: %i[create edit update remove_image destroy]
  before_action :set_medication,
                only: %i[edit update remove_image]

  def create
    @medication = Medication.create_empty(@partner.id)
    @medications = Medication.where(partner_id: @partner.id) # 全てのフードを取得

    if @medication.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "medicationTabContainer",
            partial: "medications/medication_index",
            locals: { partner: @partner, medications: @medications, remainders: @partner.remainders.where(activity_type: 'Medication') }
          )
        end
        format.html { redirect_to partner_path(@partner), notice: "新しい項目を追加しました。" }
      end
    else
      flash.now[:danger] = 'おくすりページの追加が失敗しました'
      render :show, status: :unprocessable_entity
    end
  end

  def edit
    return if @medication.remainders.present?

    @medication.remainders.build
  end

  def update
    remainder_blank_check

    if @medication.update(medication_params.except(:images))
      flash[:success] = 'おくすりの情報が更新されました。'
      redirect_to partner_path(@partner)
    else
      flash.now[:danger] = '更新が失敗しました'
      redirect_to partner_path(partner)
    end
  end

  def remove_image
    image = @medication.image
    image.purge # 画像を削除

    respond_to do |format|
      format.html { redirect_to edit_partner_medication_path(@partner, @medication), notice: '画像が削除されました' }
      format.js # JavaScriptのリクエストに対応
    end
  end

  def destroy
    @medication = Medication.find(params[:id])
    @medications = Medication.where(partner_id: @partner.id)
  
    if destroy_count(@medications, @medication, @partner)  
      respond_to do |format|
        format.html { redirect_to partner_path(@partner) }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "medicationTabContainer",
            partial: "medications/medication_index",
            locals: { partner: @partner, medications: @medications, remainders: @partner.remainders.where(activity_type: 'medication') }
          )
        end
      end
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
      :name, :amount, :place, :clinic, :note, :image,
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

  def destroy_count(medications, medication, partner)
    if medications.count > 1
      if medication
        medication.destroy
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
