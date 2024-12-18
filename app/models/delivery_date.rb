require "date"

# == Schema Information
#
# Table name: delivery_dates
#
#  id          :integer          not null, primary key
#  request_id  :integer          not null
#  resource_id :integer          not null
#  date        :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class DeliveryDate < ApplicationRecord
  belongs_to :request
  belongs_to :resource
  has_many :provider_delivery_dates
  has_many :providers, through: :provider_delivery_dates

  # Presence validations
  validates :request_id, :resource_id, :date, presence: true
end
