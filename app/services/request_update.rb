class RequestUpdate
  class RequestUpdateError < StandardError; end
  # take request data from client that contains
  # request changes and resource changes, and
  # update appropriately
  def initialize(request, params, session)
    @request = request
    @request_data = params[:request]
    @new_resources = params.dig(:resources, :new)
    @updated_resources = params.dig(:resources, :updated)
    @deleted_resources = params.dig(:resources, :deleted)
    @organization_id = session[:organization_id]
    @user_id = session[:current_person_id]
    @errors = []
  end

  def update_request
    begin
      @request.transaction do
        @request.update!(permitted_params)

        if [ "Donation", "Service" ].include? @request.request_type
          # update all delivery dates for current resources to the start_date
          resources = @request.resources
          resources.each do |resource|
            resource.delivery_date.update!(date: @request[:start_date])
          end
        end

        if !@new_resources.nil?
          create_resources if @new_resources.any?
        end
        if !@updated_resources.nil?
          update_resources if @updated_resources.any?
        end
        if !@deleted_resources.nil?
          delete_resources if @deleted_resources.any?
        end
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

  def delete_resources
    @deleted_resources.each do |resource|
      deleted_resource = Resource.find(resource[:id])
      deleted_resource.destroy!
    end
  end

  def get_errors
    @errors.join(", ")
  end

  private
    def permitted_params
      @request_data.permit(
            :status, :request_type, :title, :coordinator_id, :recipient_id,
            :notes, :start_date, :end_date, :street_line, :city, :state, :zip_code
      )
    end
end
