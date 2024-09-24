class Resource < ApplicationRecord
  belongs_to :organization
  belongs_to :request
  has_many :delivery_dates, dependent: :destroy
  has_many :providers, dependent: :destroy
end
