# Receive POST data to then
# 1. Create Request
# 2. Create Resource(s)
#
# POST Data Example:
# {
#   "request_data": {
#     "organization_id": 123,
#     "recipient_id": 123,
#     "coordinator_id": 456,
#     "creator_id": 123,
#     "request_type": "Donation",
#     "title": "This is a test",
#     "notes": "Call before dropping off",
#     "allergies": nil,
#     "start_date": ,
#     "end_date": ,
#     "start_time": ,
#     "end_time": ,
#     "street_line": "1234 Main St",
#     "city": "Norman",
#     "state": "OK",
#     "zip_code": "12345"
#   },
#   "resources_data": [
#     {
#       "request_id": 123,
#       "organization_id": 456,
#       "name": "Crayons",
#       "kind": "Donation",
#       "quantity": 20,
#     },
#     {
#       "request_id": 123,
#       "organization_id": 456,
#       "name": "Backpacks",
#       "kind": "Donation",
#       "quantity": 10,
#     }
#   ]
# }
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

# class RequestBuilder
#   def initialize(params)
#     @organization_id = session[:organization_id]
#     @creator_id = session[:current_person_id]
#     @recipient_id = params[:recipient_id]
#     @coordinator_id = params[:coordinator_id]
#     @title = params[:title]
#     @notes = params[:notes]
#     @allergies = params[:allergies]
#     @request_type = params[:request_type]
#     @start_date = params[:start_date]
#     @start_time = params[:start_time]
#     @end_date = params[:end_date]
#     @end_time = params[:end_time]
#     @street_line = params[:street_line]
#     @city = params[:city]
#     @state = params[:state]
#     @zip_code = params[:zip_code]
#     @selected_days = params[:selected_days]
#     @resources = params[:resources] # [{name, quantity}, {name, quantity}]
#   end
#
#   def calculate_delivery_dates(start_date, end_date, selected_days)
#     delivery_dates = []
#     date_range = (end_date - start_date) + 1
#     date_range.to_i.times do |n|
#       if selected_days.include? (start_date + n).wday
#         delivery_dates.push(start_date + n)
#       end
#     end
#     delivery_dates
#   end
# end

# class RequestDirector
#   def initialize(builder)
#     @builder = builder
#   end
#
#   def make_donation_request
#   end
#
#   def make_meal_request
#   end
#
#   def make_service_request
#   end
# end
class RequestCreation
  class RequestBuilder
    def build_request
      raise NotImplementedError,
        "#{self.class} has note implemented method '#{__method__}'"
    end

    def build_resources
      raise NotImplementedError,
        "#{self.class} has note implemented method '#{__method__}'"
    end

    def save_request
      raise NotImplementedError,
        "#{self.class} has note implemented method '#{__method__}'"
    end

    def save_resources
      raise NotImplementedError,
        "#{self.class} has note implemented method '#{__method__}'"
    end
  end

  # recipient_id
  # coordinator_id
  # creator_id
  # organization_id
  class DonationBuilder < RequestBuilder
    def initialize(params)
      @params = params
      reset
    end

    def reset
      @request_data = RequestData.new
      @resources_data = []
    end

    def build_request
      @params[:request_data].each do |attribute|
        @request_data.add(attribute[0], attribute[1])
      end
    end

    def build_resources
      @params[:resources_data].each do |resource|
        resource_data = ResourcesData.new
        resource.each do |attribute|
          @resources_data.push(resource_data.add(attribute[0], attribute[1]))
        end
      end
    end

    def get_request
      @request_data
    end

    def get_resources
      @resources_data
    end

    def save_request
      request = Request.new(@request_data)
      if request.save
        true
      else
        @request_data.add_errors(request.errors)
        false
      end
    end

    def save_resources
      # try to save the Resources and return true
      # else return false and errors
      saved = true
      @resources_data.each do |resource_data|
        resource = Resource.new(resource_data)
        if !resource.save
          @resources_data.add_errors(resource.errors)
          saved = false
        end
      end
      saved
    end

    def get_errors
      @request_data.get_errors
    end
  end

  class MealBuilder < RequestBuilder
    def initialize(params)
      @params = params
      reset
    end

    def reset
      @request_data = RequestData.new
      @resources_data = []
    end

    def build_request
      @params[:request_data].each do |param|
        @request_data.add(param[0], param[1])
      end
    end

    def build_resources
      # TODO: WIP
      delivery_dates = calculate_delivery_dates(
        @params[:start_date],
        @params[:end_date],
        @params[:selected_days]
      )
    end

    def get_request
      @request_data
    end

    def get_resources
      @resources_data
    end

    def save_request
      request = Request.new(@request_data)
      if request.save
        true
      else
        @request_data.add_errors(request.errors)
        false
      end
    end

    def get_errors
      @request_data.get_errors
    end

    def save_resources
      # try to save the Resources and return true
      # else return false and errors
      saved = true
      @resources_data.each do |resource_data|
        resource = Resource.new(resource_data)
        if !resource.save
          @resources_data.add_errors(resource.errors)
          saved = false
        end
      end
      saved
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

  class ServiceBuilder < RequestBuilder
    def initialize(params)
      @params = params
      reset
    end

    def reset
      @request_data = RequestData.new
      @resources_data = []
    end

    def build_request
      @params[:request_data].each do |param|
        @request_data.add(param[0], param[1])
      end
    end

    def build_resources
      @params[:resources_data].each do |resource|
        resource_data = ResourcesData.new
        resource.each do |attribute|
          @resources_data.push(resource_data.add(attribute[0], attribute[1]))
        end
      end
    end

    def get_request
      @request_data
    end

    def get_resources
      @resources_data
    end

    def save_request
      request = Request.new(@request_data)
      if request.save
        true
      else
        @request_data.add_errors(request.errors)
        false
      end
    end

    def get_errors
      @request_data.get_errors
    end

    def save_resources
      # try to save the Resources and return true
      # else return false and errors
      saved = true
      @resources_data.each do |resource_data|
        resource = Resource.new(resource_data)
        if !resource.save
          @resources_data.add_errors(resource.errors)
          saved = false
        end
      end
      saved
    end
  end

  class RequestData
    def initialize
      @data = {}
      @errors = []
    end

    def add(key, value)
      @data["#{key}"] = value
    end

    def add_errors(errors)
      @errors += errors
    end

    def get_errors
      @errors
    end
  end

  class ResourcesData
    def initialize
      @data = {}
      @errors = []
    end

    def add(key, value)
      @data["#{key}"] = value
    end

    def add_errors(errors)
      @errors += errors
    end

    def get_errors
      @errors
    end
  end
end
