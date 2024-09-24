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
require "test_helper"

class ProviderDeliveryDateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
