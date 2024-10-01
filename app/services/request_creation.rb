# Receive POST data to then
# 1. Create Request
# 2. Create Resource(s)
# 3. Create Coordinator
#
#  Request Schema
#  id              :integer          not null, primary key
#  person_id       :integer          not null
#  organization_id :integer          not null
#  request_type    :string           not null
#  title           :string           not null
#  notes           :text
#  allergies       :text
#  start_date      :date             not null
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
#  Resource Schema
#  id              :integer          not null, primary key
#  request_id      :integer          not null
#  organization_id :integer          not null
#  name            :string           not null
#  kind            :string           not null
#  quantity        :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
#  Coordinator Schema
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  request_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null

class RequestCreation
  def initialize(params)
  end
end
