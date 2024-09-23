class Provider < ApplicationRecord
  belongs_to :person
  belongs_to :resource
  has_many :delivery_dates, through: :provider_delivery_date
end
