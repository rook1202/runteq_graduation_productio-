class Food < ApplicationRecord
    belongs_to :partner
    has_many :remainders, as: :activity, dependent: :destroy 
    has_one_attached :image
    
    accepts_nested_attributes_for :remainders, allow_destroy: true
end
