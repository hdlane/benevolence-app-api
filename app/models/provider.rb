# == Schema Information
#
# Table name: providers
#
#  id          :integer          not null, primary key
#  person_id   :integer          not null
#  resource_id :integer          not null
#  quantity    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Provider < ApplicationRecord
  # Create method to default quantity to 1 if not provided

  belongs_to :person
  belongs_to :resource
  has_many :delivery_dates, through: :provider_delivery_date

  # Presence validations
  validates :person_id, :resource_id, :quantity, presence: true

  # Number validations
  validates :quantity, numericality: { greater_than_or_equal_to: 1, only_integer: true }
end
