class AdminOverviewGeneration
  def initialize(organization_id)
    @organization_id = organization_id
    @data = nil
  end

  def generate_overview
    last_sync = Organization.find(@organization_id).synced_at
    people = Person.where(organization_id: @organization_id).count
    requests = Request.where(organization_id: @organization_id)
    donations = requests.where(request_type: "Donation").count
    meals = requests.where(request_type: "Meal").count
    services = requests.where(request_type: "Service").count
    fulfilled = 0
    requests.each do |request|
      request.resources_fulfilled == request.resources.count ? fulfilled = fulfilled + 1 : nil
    end
    unfulfilled = requests.count - fulfilled

    @data = {
      "last_sync" => last_sync,
      "people" => people,
      "requests" => requests.count,
      "unfulfilled" => unfulfilled,
      "request_type" => [
        { "type" => "donation", "total" => donations },
        { "type" => "meal", "total" => meals },
        { "type" => "service", "total" => services }
      ]
    }

    @data
  end
end
