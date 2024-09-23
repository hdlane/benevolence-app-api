class Request < ApplicationRecord
  belongs_to :organization
  belongs_to :person
  has_one :coordinator
  has_many :delivery_date
  has_many :resource
end
