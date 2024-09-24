class Request < ApplicationRecord
  belongs_to :organization
  belongs_to :person
  has_one :coordinator, dependent: :destroy
  has_many :delivery_dates, dependent: :destroy
  has_many :resources, dependent: :destroy
end
