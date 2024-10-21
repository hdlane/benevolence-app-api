# TODO: Handle rolling back entire transaction if any one fails
class RequestCreation
  class RequestSaveError < StandardError; end

    def initialize(params, session)
      @request_data = {
        recipient_id: params[:request][:recipient_id],
        coordinator_id: params[:request][:coordinator_id],
        creator_id: session[:current_person_id],
        organization_id: session[:organization_id],
        status: "Active",
        request_type: params[:request][:request_type],
        title: params[:request][:title],
        notes: params[:request][:notes],
        allergies: params[:request][:allergies],
        start_date: params[:request][:start_date],
        end_date: params[:request][:end_date],
        street_line: params[:request][:street_line],
        city: params[:request][:city],
        state: params[:request][:state],
        zip_code: params[:request][:zip_code]
      }
      @request_id = nil
      @resources_data = params[:resources]
      @resources_ids = []
      @selected_days = params[:request][:selected_days]
      @delivery_dates = []
      @errors = []
    end

    def save_request
      request = Request.new(@request_data)
      if request.save
        @request_id = request.id
      else
            @errors += request.errors.full_messages
            raise RequestCreation::RequestSaveError, @errors
      end
    end

    def save_resources
      # for meals, create resource for each delivery date
      if @request_data[:request_type] == "Meal" && @selected_days
        calculate_delivery_dates(
          @request_data[:start_date],
          @request_data[:end_date],
          @selected_days
        )
          if @delivery_dates.empty?
            @errors += [ "no delivery dates are within date range and selected days" ]
          else
            @delivery_dates.each do
              resource = Resource.new(
                request_id: @request_id,
                organization_id: @request_data[:organization_id],
                name: nil,
                kind: "Meal",
                assigned: false,
                quantity: 1
              )
              if resource.save
                @resources_ids.push(resource.id)
              else
                    @errors += resource.errors.full_messages
                    raise RequestCreation::RequestSaveError, @errors.join(", ")
                    break
              end
            end
          end
          save_delivery_dates
      elsif @request_data[:request_type] == "Donation" || @request_data[:request_type] == "Service"
        @resources_data.each do |resource_data|
          resource = Resource.new(
                request_id: @request_id,
                organization_id: @request_data[:organization_id],
                name: resource_data[:name],
                kind: @request_data[:request_type],
                assigned: false,
                quantity: resource_data[:quantity]
          )
          if resource.save
            @resources_ids.push(resource.id)
          else
                @errors += resource.errors.full_messages
                raise RequestCreation::RequestSaveError, @errors.join(", ")
                break
          end
        end
        save_delivery_dates
      end
    end

    def save_delivery_dates
      # for meals, create delivery dates and tie to previously created resources
      if @request_data[:request_type] == "Meal" && @selected_days
        if @delivery_dates.empty?
          @errors += [ "no delivery dates are within date range and selected days" ]
        else
          @delivery_dates.each_with_index do |date, idx|
            delivery_date = DeliveryDate.new(
              request_id: @request_id,
              resource_id: @resources_ids[idx],
              date: date
            )
            if !delivery_date.save
              @errors += resource.errors.full_messages
              raise RequestCreation::RequestSaveError, @errors.join(", ")
              break
            end
          end
        end
      elsif @request_data[:request_type] == "Donation" || @request_data[:request_type] == "Service"
          @resources_ids.each_with_index do |resource_id, idx|
            delivery_date = DeliveryDate.new(
              request_id: @request_id,
              resource_id: resource_id,
              date: @request_data[:start_date]
            )
            if !delivery_date.save
              @errors += resource.errors.full_messages
              raise RequestCreation::RequestSaveError, @errors.join(", ")
              break
            end
          end
      end
    end

    def get_errors
      @errors.join(", ")
    end

    def get_id
      @request_id
    end

    private
      def calculate_delivery_dates(start_date, end_date, selected_days)
        # find the dates that match the selected days within the provided date range
        start_date = start_date.to_datetime
        end_date = end_date.to_datetime
        date_range = (end_date - start_date) + 1
        date_range.to_i.times do |n|
          if selected_days.include? (start_date + n).wday
            @delivery_dates.push(start_date + n)
          end
        end
      end
end
