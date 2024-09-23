class DeliveryDate < ApplicationRecord
  belongs_to :request
  belongs_to :resource
  has_many :providers, through: :provider_delivery_date
end
