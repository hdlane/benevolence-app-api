# == Schema Information
#
# Table name: coordinators
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  request_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class CoordinatorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
