# frozen_string_literal: true

# ペットについての基本情報を管理するコントローラーです。
class PartnersController < ApplicationController
  before_action :set_partner, only: %i[edit update destroy show remove_image]

  def index
    @partners = current_user.partners.includes(:user)
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
    food_walk_medication_set
    @pet_foods = helpers.generate_food_array(@food, @food_remainders)
    @pet_walks = helpers.generate_walk_array(@walk, @walk_remainders)
    @pet_medications = helpers.generate_medication_array(@medication, @medication_remainders)
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
    @partner.destroy!
    flash[:success] = 'パートナー情報を削除しました'
    redirect_to partners_path, status: :see_other
  end

  def remove_image
    @image = @partner.image
    @image.purge # 画像を削除

    respond_to do |format|
      format.html { redirect_to edit_partner_path(@partner), notice: '画像が削除されました' }
      format.js # JavaScriptのリクエストに対応
    end
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :animal_type, :breed, :gender, :birthday, :weight, :image)
  end

  def set_partner
    @partner = current_user.partners.find(params[:id])
  end

  def set_food
    @food, @food_remainders = set_resource('food', @partner)
  end

  def set_walk
    @walk, @walk_remainders = set_resource('walk', @partner)
  end

  def set_medication
    @medication, @medication_remainders = set_resource('medication', @partner)
  end

  def food_walk_medication_set
    set_food
    set_walk
    set_medication
  end
end
