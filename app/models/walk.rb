# frozen_string_literal: true

# ペットのおくすりに関するモデルです。
class Walk < ApplicationRecord
  belongs_to :partner
  has_many :remainders, as: :activity, dependent: :destroy

  accepts_nested_attributes_for :remainders, allow_destroy: true
end
