class Person < ApplicationRecord
  has_many :organizations, through: :organization_membership
  has_many :coordinators
  has_many :providers
  has_many :requests
end
