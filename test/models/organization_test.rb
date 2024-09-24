# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string           not null
#  synced_at  :datetime
#  pco_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
