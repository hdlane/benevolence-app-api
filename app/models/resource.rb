class Resource < ApplicationRecord
  belongs_to :request
  has_many :delivery_date
  has_many :provider
end
