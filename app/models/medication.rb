# frozen_string_literal: true

# ペットのおくすりに関するモデルです。
class Medication < ApplicationRecord
  belongs_to :partner
  has_many :remainders, as: :activity,
                        dependent: :destroy
  has_one_attached :image

  accepts_nested_attributes_for :remainders,
                                allow_destroy: true

  def self.create_empty(partner_id)
    create!(partner_id: partner_id, name: '', place: '', clinic: '', amount: '', note: '')
  end

end
