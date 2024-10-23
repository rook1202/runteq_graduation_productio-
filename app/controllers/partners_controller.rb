class PartnersController < ApplicationController
  
  def index
  end

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(partner_params)
    if @partner.save
      flash[:success] = 'ユーザー登録が完了しました'
      redirect_to root_path 
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :email, :password, :password_confirmation)
  end

end
