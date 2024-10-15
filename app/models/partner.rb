class Partner < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :foods
  has_many :walks
  has_many :medications
  has_many :remainders
end
