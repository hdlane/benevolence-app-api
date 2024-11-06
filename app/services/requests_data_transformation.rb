class RequestsDataTransformation
  def initialize(organization_id: nil, request: nil)
    @organization_id = organization_id
    @request = request
    @data = nil
  end

  def get_requests
    @data = []
    requests = Request.where(organization_id: @organization_id)
    requests.each do |request|
      @data.push({
        "id" => request.id,
        "title" => request.title,
        "start_date" => request.start_date,
        "end_date" => request.end_date,
        "request_type" => request.request_type,
        "num_resources" => request.resources.count,
        "fulfilled" => request.resources_fulfilled,
        "status" => request.status
      })
    end
    @data
  end

  def get_request
    resources = Resource.left_joins(:delivery_date, providers: :person)
      .select(
        "resources.*",
        "delivery_dates.date",
        "delivery_dates.id as delivery_date_id",
        "concat(people.id, ',', people.name, ',', providers.quantity, ',', providers.id) as provider"
      )
      .where(request_id: @request.id)
      .group_by(&:id)

    coordinator = Person.find(@request.coordinator_id)

    # add each provider as array element in providers hash
    # to truncate JSON response to have one resource object
    # instead of separate resources per provider signed up

    formatted_resources = []

    resources.each do |resource_id, resource_entries|
      providers = []

      resource = resource_entries.first

      resource_entries.each do |resource|
        provider_data = resource.provider.split(",")

        person_id = provider_data[0]
        if person_id != nil
          provider_name = provider_data[1]
          provider_quantity = provider_data[2]
          provider_id = provider_data[3]
          providers.push({
            "name" => provider_name,
            "id" => person_id.to_i,
            "quantity" => provider_quantity.to_i,
            "provider_id" => provider_id.to_i
          })
        end
      end

      formatted_resources.push({
        "assigned" => resource.assigned,
        "created_at" => resource.created_at,
        "date" => resource.date,
        "delivery_date_id" => resource.delivery_date_id,
        "id" => resource.id,
        "kind" => resource.kind,
        "name" => resource.name,
        "organization_id" => resource.organization_id,
        "providers" => providers,
        "quantity" => resource.quantity,
        "request_id" => resource.request_id,
        "updated_at" => resource.updated_at
      })
    end

    @data = {
      "id" => @request.id,
      "status" => @request.status,
      "recipient_id" => @request.recipient_id,
      "recipient_name" => Person.find(@request.recipient_id).name,
      "coordinator_id" => @request.coordinator_id,
      "coordinator_name" => coordinator.name,
      "coordinator_email" => coordinator.email,
      "coordinator_phone_number" => coordinator.phone_number,
      "creator_name" => Person.find(@request.creator_id).name,
      "organization_id" => @request.organization_id,
      "request_type" => @request.request_type,
      "title" => @request.title,
      "notes" => @request.notes,
      "allergies" => @request.allergies,
      "start_date" => @request.start_date,
      "end_date" => @request.end_date,
      "resources" => formatted_resources,
      "street_line" => @request.street_line,
      "city" => @request.city,
      "state" => @request.state,
      "zip_code" => @request.zip_code,
      "created_at" => @request.created_at,
      "updated_at" => @request.updated_at
    }
    puts @data
    @data
  end
end
