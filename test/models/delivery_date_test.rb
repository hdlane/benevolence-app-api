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
require "test_helper"

class DeliveryDateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
