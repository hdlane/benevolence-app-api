class Organization < ApplicationRecord
  has_many :people, dependent: :destroy_all
  has_many :requests, dependent: :destroy_all
end
