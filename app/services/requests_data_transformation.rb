class RequestsDataTransformation
  def initialize(organization_id)
    @organization_id = organization_id
    @requests_data = []
  end

  def get_requests
    requests = Request.where(organization_id: @organization_id)
    requests.each do |request|
      @requests_data.push({
        "id" => request.id,
        "title" => request.title,
        "start_date" => request.start_date,
        "end_date" => request.end_date,
        "request_type" => request.request_type,
        "num_resources" => request.resources.count
      })
    end
    @requests_data
  end
end
