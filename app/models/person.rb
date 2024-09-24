class Person < ApplicationRecord
  belongs_to :organization
  has_many :coordinators, dependent: :destroy_all
  has_many :providers, dependent: :destroy_all
  has_many :requests, dependent: :destroy_all
end
