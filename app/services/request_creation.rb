# Receive POST data to then
# 1. Create Request
# 2. Create Resource(s)
# 3. Create Coordinator
#
#  Request Schema
#  id              :integer          not null, primary key
#  recipient_id    :integer          not null
#  coordinator_id  :integer          not null
#  creator_id      :integer          not null
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

class RequestCreation
  def initialize(params)
    @organization_id = session[:organization_id]
    @creator_id = session[:current_person_id]
    @recipient_id = params[:recipient_id]
    @coordinator_id = params[:coordinator_id]
    @title = params[:title]
    @notes = params[:notes]
    @allergies = params[:allergies]
    @request_type = params[:request_type]
    @start_date = params[:start_date]
    @start_time = params[:start_time]
    @end_date = params[:end_date]
    @end_time = params[:end_time]
    @street_line = params[:street_line]
    @city = params[:city]
    @state = params[:state]
    @zip_code = params[:zip_code]
    @resources = params[:resources]
  end
  def calculate_delivery_dates(start_date, end_date, selected_days)
    delivery_dates = []
    date_range = (end_date - start_date) + 1
    date_range.to_i.times do |n|
      if selected_days.include? (start_date + n).wday
        delivery_dates.push(start_date + n)
      end
    end
    delivery_dates
  end
end
