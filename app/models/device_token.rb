class DeviceToken < ApplicationRecord
  belongs_to :partner
  validates :token, presence: true, uniqueness: true
end
