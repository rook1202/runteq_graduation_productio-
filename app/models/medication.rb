# frozen_string_literal: true

# ペットのおくすりに関するモデルです。
class Medication < ApplicationRecord
  belongs_to :partner
  has_many :remainders, as: :activity, dependent: :destroy
  has_many_attached :images

  accepts_nested_attributes_for :remainders, allow_destroy: true
end
