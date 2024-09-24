class Person < ApplicationRecord
  belongs_to :organization
  has_many :coordinators, dependent: :destroy
  has_many :providers, dependent: :destroy
  has_many :requests, dependent: :destroy
end
