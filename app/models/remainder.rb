# frozen_string_literal: true

# ペットの各行動時間に関するモデルです。
class Remainder < ApplicationRecord
  belongs_to :partner
  belongs_to :activity, polymorphic: true # 複数の活動（Food, Walk, Medicationなど）を扱う
end
