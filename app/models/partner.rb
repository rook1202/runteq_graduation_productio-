class Partner < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :foods
  has_many :walks
  has_many :medications
  has_many :remainders

  enum gender: { male: 0, female: 1, unknown: 2 }
  
  validates :name, presence: true
  validates :gender, presence: true
  validates :animal_type, presence: true

end
