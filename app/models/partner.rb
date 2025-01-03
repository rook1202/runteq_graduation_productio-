# frozen_string_literal: true

# ペットの基本情報に関するモデルです。
class Partner < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: :partners
  has_many :medications, dependent: :destroy
  has_many :foods, dependent: :destroy
  has_many :walks, dependent: :destroy
  has_many :remainders, dependent: :destroy
  has_many :partner_shares, dependent: :destroy
  has_many :tokens, dependent: :destroy

  has_one_attached :image

  validates :name, presence: true
  validates :gender, presence: true
  validates :animal_type, presence: true

  enum gender: { male: 0, female: 1, unknown: 2 }

  # medications、foods、walksの空レコードを生成する
  after_create :initialize_associated_records

  def self.gender_options
    {
      'オス' => 'male',
      'メス' => 'female',
      '性別不明' => 'unknown'
    }
  end

  # 性別を日本語で表示するメソッド（表示時に使う）
  def gender_in_japanese
    self.class.gender_options.key(gender)
  end

  def age
    return unless birthday

    today = Time.zone.today
    age = today.year - birthday.year
    # 誕生日がまだ来ていない場合
    age -= 1 if today < birthday + age.years
    age
  end

  private

  def initialize_associated_records
    # 各モデルのインスタンス作成
    foods.create!(manufacturer: '', category: '', amount: '', place: '', note: '')
    walks.create!(time: '', note: '')
    medications.create!(name: '', place: '', clinic: '', amount: '', note: '')
  end
end
