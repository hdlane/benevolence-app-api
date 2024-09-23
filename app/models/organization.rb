class Organization < ApplicationRecord
  has_many :people, through: :organization_membership
  has_many :requests
end
