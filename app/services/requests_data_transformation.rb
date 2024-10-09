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
        "num_resources" => request.resources.count
      })
    end
    @data
  end

  def get_request
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
      "start_time" => @request.start_time,
      "end_date" => @request.end_date,
      "end_time" => @request.end_time,
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
