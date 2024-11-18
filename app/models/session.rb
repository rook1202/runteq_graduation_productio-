# frozen_string_literal: true

# ユーザーのログインに関するモデルです。
class Session < ApplicationRecord
  belongs_to :user
end
