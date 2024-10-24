class Partner < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :foods
  has_many :walks
  has_many :medications
  has_many :remainders

  enum gender: { male: 0, female: 1, unknown: 2 }

  def self.gender_options
    {
      "オス" => "male",
      "メス" => "female",
      "性別不明" => "unknown"
    }
  end

  # 性別を日本語で表示するメソッド（表示時に使う）
  def gender_in_japanese
    self.class.gender_options.key(gender)
  end

  def age
    return unless birthday
    today = Date.today
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years # 誕生日がまだ来ていない場合
    age
  end
  
  validates :name, presence: true
  validates :gender, presence: true
  validates :animal_type, presence: true

end
