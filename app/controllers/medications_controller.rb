class MedicationsController < ApplicationController
  before_action :set_partner, only: [:edit, :update, :add_remainder_field]
  before_action :set_medication, only: [:edit, :update]

  def edit
    @medication.remainders.build if @medication.remainders.blank?
  end

  def update
    # 空のtimeを持つremainderを除外する
    filtered_remainders = params[:medication][:remainders_attributes].reject do |_, r|
      r[:time].blank?
    end
    # フィルタリングしたremaindersを再構築
    params[:medication][:remainders_attributes] = filtered_remainders

    if @medication.update(medication_params)
      flash[:success] = 'おくすりの情報が更新されました。'
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

  def set_medication
    @medication = @partner.medications.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound, "Medication not found" if @medication.nil?
  end

  def medication_params
    params.require(:medication).permit(
      :name, :amount, :place, :clinic, :note,
      remainders_attributes: [:id, :time, :notification_status, :partner_id, :_destroy]
    )
  end
  
end
