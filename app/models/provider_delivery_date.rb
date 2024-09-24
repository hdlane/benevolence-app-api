# == Schema Information
#
# Table name: provider_delivery_dates
#
#  id               :integer          not null, primary key
#  delivery_date_id :integer          not null
#  provider_id      :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class ProviderDeliveryDate < ApplicationRecord
  belongs_to :provider
  belongs_to :delivery_date
  
  validates :delivery_date_id, :provider_id, presence: true
end
