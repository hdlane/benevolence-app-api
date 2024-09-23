class Provider < ApplicationRecord
  belongs_to :person
  belongs_to :resource
  has_many :delivery_date, through: :provider_delivery_date
end
