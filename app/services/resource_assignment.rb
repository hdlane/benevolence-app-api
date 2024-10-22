class ResourceAssignment
  class ResourceAssignmentError < StandardError; end

  def initialize(resource, params, session)
    @resource = resource
    @resource_id = params[:resource_id]
    @provider_id = session[:current_person_id]
    @delivery_date_id = params[:delivery_date_id]
    @name = params[:name]
    @quantity = params[:quantity]
    @errors = []
  end

  def assign_resource
    begin
      @resource.transaction do
        @resource.assign_resource!(@quantity)
        @resource.update!(name: @name)
        Provider.create(person_id: @provider_id, resource_id: @resource_id, quantity: @quantity)
        ProviderDeliveryDate.create(provider_id: @provider_id, delivery_date_id: @delivery_date_id)
      end
    rescue ActiveRecord::RecordInvalid => invalid
      @errors += invalid.record.errors.full_messages
      raise ResourceAssignment::ResourceAssignmentError, @errors
    rescue ActiveRecord::RecordNotFound => e
      @errors += e.errors.full_messages
      raise ResourceAssignment::ResourceAssignmentError, @errors
    end
  end

  def get_errors
    @errors.join(", ")
  end
end
