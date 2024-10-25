class ResourceAssignment
  class ResourceAssignmentError < StandardError; end

  def initialize(resource, params, session)
    @resource = resource
    @resource_id = params[:resource_id]
    @user_id = session[:current_person_id]
    @delivery_date_id = params[:delivery_date_id]
    @name = params[:name]
    @quantity = params[:quantity]
    @errors = []
  end

  def assign_resource
    begin
      @resource.transaction do
        user_provider_present = @resource.providers.distinct.pluck(:person_id).include?(@user_id)

        if !user_provider_present
          @resource.assign_resource!(@quantity)
          @resource.update!(name: @name)
          new_provider = Provider.create(person_id: @user_id, resource_id: @resource_id, quantity: @quantity)
          ProviderDeliveryDate.create(provider_id: new_provider.id, delivery_date_id: @delivery_date_id)
        else
          user_provider_id = @resource.providers.where(person_id: @user_id).distinct.pluck("id")[0]
          user_provider = Provider.find(user_provider_id)
          prev_quantity = user_provider.quantity
          quantity_diff = @quantity - prev_quantity
          user_provider.update!(quantity: @quantity)
          if quantity_diff.positive?
            @resource.assign_resource!(quantity_diff)
          else
            @resource.unassign_resource!(quantity_diff.abs)
          end
        end
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
