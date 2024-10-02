# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  organization_id :integer          not null
#  first_name      :string           not null
#  last_name       :string           not null
#  name            :string           not null
#  email           :string
#  phone_number    :string
#  is_admin        :boolean          not null
#  pco_person_id   :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
