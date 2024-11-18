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
    food_array
    walk_array
    medication_array
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
    @food = @partner.foods.find_by(id: params[:id])
    @food_remainders = @partner.remainders.where(activity_type: 'Food')
    redirect_to partner_path unless @food
  end

  def set_walk
    @walk = @partner.walks.find_by(partner_id: params[:id])
    @walk_remainders = @partner.remainders.where(activity_type: 'Walk')
    redirect_to partner_path unless @walk
  end

  def set_medication
    @medication = @partner.medications.find_by(partner_id: params[:id])
    @medication_remainders = @partner.remainders.where(activity_type: 'Medication')
    redirect_to partner_path unless @medication
  end

  def food_walk_medication_set
    set_food
    set_walk
    set_medication
  end

  def food_array
    @pet_foods = [
      { label: 'ごはんのメーカー', content: @food.manufacturer },
      { label: 'さらに詳しい区分', content: @food.category },
      { label: 'ごはんの量', content: @food.amount },
      { label: 'ごはんの時間', content: @food_remainders.map(&:time).join(', ') }, # @food_remaindersから時間を取得
      { label: '置き場所', content: @food.place },
      { label: 'メモ', content: @food.note }
    ]

    @pet_foods.reject! { |item| item[:content].blank? }
  end

  def walk_array
    @pet_walks = [
      { label: '1日のさんぽ時間', content: @walk.time },
      { label: 'さんぽの時間', content: @walk_remainders.map(&:time).join(', ') },
      { label: 'メモ', content: @walk.note }
    ]

    @pet_walks.reject! { |item| item[:content].blank? }
  end

  def medication_array
    @pet_medications = [
      { label: 'おくすりの名前', content: @medication.name },
      { label: 'おくすりの量', content: @medication.amount },
      { label: 'おくすりの時間', content: @medication_remainders.map(&:time).join(', ') }, # @food_remaindersから時間を取得
      { label: '置き場所', content: @medication.place },
      { label: 'メモ', content: @medication.note }
    ]

    @pet_medications.reject! { |item| item[:content].blank? }
  end
end
