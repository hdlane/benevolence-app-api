class ProviderDeliveryDate < ApplicationRecord
  belongs_to :provider
  belongs_to :delivery_date
end
