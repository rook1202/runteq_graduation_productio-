# frozen_string_literal: true

# ペットの基本情報について使用されるヘルパーメソッドを提供します。
module PartnersHelper
  def generate_food_array(food, food_remainders)
    pet_foods = [
      { label: 'ごはんのメーカー', content: food.manufacturer },
      { label: 'さらに詳しい区分', content: food.category },
      { label: 'ごはんの量', content: food.amount },
      { label: 'ごはんの時間', content: food_remainders.map(&:time).join(', ') },
      { label: '置き場所', content: food.place },
      { label: 'メモ', content: food.note }
    ]
    pet_foods.reject { |item| item[:content].blank? }
  end

  def generate_walk_array(walk, walk_remainders)
    pet_walks = [
      { label: '1日のさんぽ時間', content: walk.time },
      { label: 'さんぽの時間', content: walk_remainders.map(&:time).join(', ') },
      { label: 'メモ', content: walk.note }
    ]
    pet_walks.reject { |item| item[:content].blank? }
  end

  def generate_medication_array(medication, medication_remainders)
    pet_medications = [
      { label: 'おくすりの名前', content: medication.name },
      { label: 'おくすりの量', content: medication.amount },
      { label: 'おくすりの時間', content: medication_remainders.map(&:time).join(', ') },
      { label: '置き場所', content: medication.place },
      { label: 'メモ', content: medication.note }
    ]
    pet_medications.reject { |item| item[:content].blank? }
  end
end
