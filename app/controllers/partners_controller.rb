class PartnersController < ApplicationController
  
  def index
    @partners = Partner.all
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
    @partner = Partner.find_by(id: params[:id])
    if @partner.nil?
      redirect_to partner_path and return
    end
  end

  def edit
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :animal_type, :breed, :gender, :birthday, :weight, :note)
  end

end
