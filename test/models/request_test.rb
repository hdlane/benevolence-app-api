# == Schema Information
#
# Table name: requests
#
#  id              :integer          not null, primary key
#  person_id       :integer          not null
#  organization_id :integer          not null
#  type            :string           not null
#  title           :string           not null
#  notes           :text
#  allergies       :text
#  start_date      :date
#  start_time      :time
#  end_date        :date
#  end_time        :time
#  street_line     :string
#  city            :string
#  state           :string
#  zip_code        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class RequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
