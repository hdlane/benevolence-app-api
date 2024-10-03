# TODO: Handle rolling back entire transaction if any one fails
class RequestCreation
    def initialize(params)
      @request_data = params[:request_data]
      @request_id = nil
      @resources_data = params[:resources_data]
      @resources_ids = []
      @selected_days = params[:selected_days]
      @delivery_dates = []
      @errors = []
    end

    def save_request
      request = Request.new(@request_data)
      if request.save
        @request_id = request.id
        true
      else
        @errors += request.errors.full_messages
        false
      end
    end

    def save_resources
      saved = true
      # for meals, create resource for each delivery date
      if @request_data[:request_type] == "Meal" && @selected_days
        calculate_delivery_dates(
          @request_data[:start_date],
          @request_data[:end_date],
          @selected_days
        )
          if @delivery_dates.empty?
            @errors += [ "no delivery dates are within date range and selected days" ]
            saved = false
          else
            @delivery_dates.each do
              resource = Resource.new(
                request_id: @request_id,
                organization_id: @request_data[:organization_id],
                name: nil,
                kind: "Meal",
                quantity: 1
              )
              if resource.save
                @resources_ids.push(resource.id)
              else
                @errors += resource.errors.full_messages
                saved = false
                break
              end
            end
          end
      else
        @resources_data.each do |resource_data|
          resource = Resource.new(resource_data)
          if resource.save
            @resources_ids.push(resource.id)
          else
            @errors += resource.errors.full_messages
            saved = false
            break
          end
        end
      end
      saved
    end

    def save_delivery_dates
      saved = true
      # for meals, create delivery dates and tie to previously created resources
      if @request_data[:request_type] == "Meal" && @selected_days
        if @delivery_dates.empty?
          @errors += [ "no delivery dates are within date range and selected days" ]
          saved = false
        else
          @delivery_dates.each_with_index do |date, idx|
            delivery_date = DeliveryDate.new(
              request_id: @request_id,
              resource_id: @resources_ids[idx],
              date: date
            )
            if !delivery_date.save
              @errors += delivery_date.errors.full_messages
              saved = false
              break
            end
          end
        end
      end
      saved
    end

    def get_errors
      @errors
    end

    def calculate_delivery_dates(start_date, end_date, selected_days)
      # find the dates that match the selected days within the provided date range
      date_range = (end_date - start_date) + 1
      date_range.to_i.times do |n|
        if selected_days.include? (start_date + n).wday
          @delivery_dates.push(start_date + n)
        end
      end
    end
end
