class PartnersController < ApplicationController
  before_action :set_partner, only: %i[edit update destroy show]
  
  def index
    @partners = current_user.partners
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    @partner.owner_id = current_user.id # ここでログインユーザーのIDを設定
    if @partner.save
      flash[:success] = '登録が完了しました'
      redirect_to partners_path 
    else
      flash.now[:danger] = '登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    set_food
    set_walk
    set_medication
    set_remainders
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
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :animal_type, :breed, :gender, :birthday, :weight)
  end

  def set_partner
    @partner = current_user.partners.find(params[:id])
  end

  def set_food
    @food = @partner.foods.find_by(partner_id: params[:id])
    if @food.nil?
      redirect_to partner_path and return
    end
  end

  def set_walk
    @walk = @partner.walks.find_by(partner_id: params[:id])
    if @walk.nil?
      redirect_to partner_path and return
    end
  end

  def set_medication
    @medication = @partner.medications.find_by(partner_id: params[:id])
    if @medication.nil?
      redirect_to partner_path and return
    end
  end

  def set_remainders
    @food_remainders = @partner.remainders.where(activity_type: 'Food')
    @walk_remainders = @partner.remainders.where(activity_type: 'Walk')
    @medication_remainders = @partner.remainders.where(activity_type: 'Medication')
  end

end
