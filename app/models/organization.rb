class Organization < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :requests, dependent: :destroy
end
