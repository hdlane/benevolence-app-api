class Person < ApplicationRecord
  has_many :organization, through: :organization_membership
  has_many :coordinator
  has_many :provider
  has_many :request
end
