require "pco_api"

API_URL ||= Rails.application.credentials.api_url

class PcoApiSync
  def initialize(oauth_token)
    @oauth_token = oauth_token
    @organization_data = {}
    @people_data = {}
    @api = api(oauth_token.token)
  end

  def get_organization_data
    response = @api.people.v2.get
    data = response["data"]
    @organization_data["access_token"] = @oauth_token.token
    @organization_data["refresh_token"] = @oauth_token.refresh_token
    @organization_data["token_expires_at"] = @oauth_token.expires_at
    @organization_data["pco_id"] = data["id"]
    @organization_data["name"] = data["attributes"]["name"]

    @organization_data
  end

  def get_people_data(me = false)
    if me
      # response is a Hash, so add to Array
      response_array = []
      response = @api.people.v2.me.get(include: "emails,phone_numbers")
      response_array.push(response["data"])
      parse_response_data(response_array)
    else
      response = @api.people.v2.people.get(include: "emails,phone_numbers")
      parse_response_data(response["data"])
    end
    parse_response_included(response["included"])

    @people_data.values
  end

  def sync_organization
    @organization_data = {}
    response = @api.people.v2.get
    data = response["data"]
    @organization_data["name"] = data["attributes"]["name"]
    @organization_data
  end

  def sync_people
    @people_data = {}
    response = @api.people.v2.people.get(include: "emails,phone_numbers", per_page: 100, offset: 0)
    parse_response_data(response["data"])
    parse_response_included(response["included"])

    # get first 100 (max results per response) and get the rest if needed
    if !(response["meta"]["total_count"] <= 100)
      offset = response["meta"]["next"]["offset"]
      recursive_sync_people(@api, offset)
    end

    @people_data.values
  end

  private
    def api(token)
      PCO::API.new(url: API_URL, oauth_access_token: token)
    end

    def parse_response_data(response)
      response.each do |person|
        people_permissions = person["attributes"]["people_permissions"]
        @people_data[person["id"]] = {
          "first_name" => person["attributes"]["first_name"],
          "last_name" => person["attributes"]["last_name"],
          "name" => person["attributes"]["name"],
          "is_admin" => (
            (people_permissions && (people_permissions.include? "Editor")) ||
            (people_permissions && (people_permissions.include? "Manager")) ? true : false
          ),
          "pco_person_id" => person["id"]
        }
      end
    end

    def parse_response_included(response)
      response.each do |item|
        if item["type"] == "Email" && item["attributes"]["primary"] == true
          person_id = item["relationships"]["person"]["data"]["id"]
          @people_data[person_id]["email"] = item["attributes"]["address"]
        elsif item["type"] == "PhoneNumber" && item["attributes"]["primary"] == true
          person_id = item["relationships"]["person"]["data"]["id"]
          @people_data[person_id]["phone_number"] = item["attributes"]["number"]
        end
      end
    end

    def recursive_sync_people(api, offset)
      response = @api.people.v2.people.get(include: "emails,phone_numbers", per_page: 100, offset: offset)
      parse_response_data(response["data"])
      parse_response_included(response["included"])
      if response["meta"]["next"]
        recursive_sync_people(api, offset = response["meta"]["next"]["offset"])
      end
    end
end
