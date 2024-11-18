# frozen_string_literal: true

class Remainder < ApplicationRecord
  belongs_to :partner
  belongs_to :activity, polymorphic: true # 複数の活動（Food, Walk, Medicationなど）を扱う
end
