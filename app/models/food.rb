# frozen_string_literal: true

# ペットのごはんに関するモデルです。
class Food < ApplicationRecord
  belongs_to :partner
  has_many :remainders, as: :activity,
                        dependent: :destroy
  has_one_attached :image

  accepts_nested_attributes_for :remainders,
                                allow_destroy: true

  def self.create_empty(partner_id)
    create!(partner_id: partner_id, manufacturer: '', category: '', amount: '', place: '', note: '')
  end
end
