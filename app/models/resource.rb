class Resource < ApplicationRecord
  belongs_to :request
  has_many :delivery_dates
  has_many :providers
end
