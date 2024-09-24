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
  belongs_to :person
  belongs_to :resource
  has_many :delivery_dates, through: :provider_delivery_date

  validates :person_id, :resource_id, :quantity, presence: true
end
