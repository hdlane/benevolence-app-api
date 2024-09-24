# == Schema Information
#
# Table name: resources
#
#  id              :integer          not null, primary key
#  request_id      :integer          not null
#  organization_id :integer          not null
#  name            :string           not null
#  kind            :string           not null
#  quantity        :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class ResourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
