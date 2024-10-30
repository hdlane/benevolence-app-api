class RequestUpdate
  class RequestUpdateError < StandardError; end
  # take request data from client that contains
  # request changes and resource changes, and
  # update appropriately
  def initialize(request, params, session)
    @request = request
    @request_data = params[:request]
    @new_resources = params[:resources][:new] || []
    @updated_resources = params[:resources][:updated] || []
    @organization_id = session[:organization_id]
    @user_id = session[:current_person_id]
    @errors = []
  end

  def update_request
    begin
      @request.transaction do
        @request.update!(
          request_type: @request_data[:request_type],
          title: @request_data[:title],
          coordinator_id: @request_data[:coordinator_id],
          recipient_id: @request_data[:recipient_id],
          notes: @request_data[:notes],
          start_date: @request_data[:start_date],
          end_date: @request_data[:end_date],
          street_line: @request_data[:street_line],
          city: @request_data[:city],
          state: @request_data[:state],
          zip_code: @request_data[:zip_code]
        )

        create_resources if @new_resources.any?
        update_resources if @updated_resources.any?
      end
    rescue ActiveRecord::RecordInvalid => invalid
      @errors += invalid.record.errors.full_messages
      raise RequestUpdate::RequestUpdateError, @errors
    rescue ActiveRecord::RecordNotFound => e
      @errors += e.message
      raise RequestUpdate::RequestUpdateError, @errors
    end
  end

  def create_resources
    @new_resources.each do |resource|
      new_resource = Resource.create!(
        request_id: @request[:id],
        organization_id: @organization_id,
        name: resource[:name],
        kind: @request[:request_type],
        quantity: resource[:quantity],
        assigned: 0,
      )

      DeliveryDate.create!(
        request_id: @request[:id],
        resource_id: new_resource.id,
        date: @request[:start_date]
      )
    end
  end

  def update_resources
    @updated_resources.each do |resource|
      updated_resource = Resource.find(resource[:id])
      updated_resource.update!(
        request_id: @request[:id],
        organization_id: @organization_id,
        name: resource[:name],
        kind: @request[:request_type],
        quantity: resource[:quantity]
      )
    end
  end

  def get_errors
    @errors.join(", ")
  end
end
