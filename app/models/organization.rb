class Organization < ApplicationRecord
  has_many :person, through: :organization_membership
  has_many :request
end
