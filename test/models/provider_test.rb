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
require "test_helper"

class ProviderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
