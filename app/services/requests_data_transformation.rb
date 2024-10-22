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
        "assigned" => request.resources.where.not(assigned: false).count
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
        "resources.quantity",
        "people.id as provider_id",
        "people.name as provider_name"
      )
      .where(request_id: @request.id)
    @data = {
      "id" => @request.id,
      "recipient_name" => Person.find(@request.recipient_id).name,
      "coordinator_name" => Person.find(@request.coordinator_id).name,
      "creator_name" => Person.find(@request.creator_id).name,
      "organization_id" => @request.organization_id,
      "request_type" => @request.request_type,
      "title" => @request.title,
      "notes" => @request.notes,
      "allergies" => @request.allergies,
      "start_date" => @request.start_date,
      "end_date" => @request.end_date,
      "resources" => resources,
      "street_line" => @request.street_line,
      "city" => @request.city,
      "state" => @request.state,
      "zip_code" => @request.zip_code,
      "created_at" => @request.created_at,
      "updated_at" => @request.updated_at
    }
    @data
  end
end
