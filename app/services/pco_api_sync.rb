require "pco_api"

API_URL ||= Rails.application.credentials.api_url

class PcoApiSync
  def initialize(oauth_token)
    @oauth_token = oauth_token
  end

  def get_organization_data
    organization_data = {}
    response = api.people.v2.get
    data = response["data"]
    organization_data["access_token"] = @oauth_token.token
    organization_data["refresh_token"] = @oauth_token.refresh_token
    organization_data["pco_id"] = data["id"]
    organization_data["name"] = data["attributes"]["name"]

    return organization_data
  end

  def get_authorizing_user_data
    person_data = {}
    response = api.people.v2.me.get(include: "emails,phone_numbers")
    data = response["data"]
    included = response["included"]
    included.each do |item|
      if item["type"] == "Email" && item["attributes"]["primary"] == true
        person_data["email"] = item["attributes"]["address"]
      end
      if item["type"] == "PhoneNumber" && item["attributes"]["primary"] == true
        person_data["phone_number"] = item["attributes"]["number"]
      end
    end
    people_permissions = data["attributes"]["people_permissions"]
    person_data["is_admin"] = (people_permissions.include?"Editor") || (people_permissions.include?"Manager") ? true : false
    person_data["first_name"] = data["attributes"]["first_name"]
    person_data["last_name"] = data["attributes"]["last_name"]
    person_data["pco_person_id"] = data["id"]

    return person_data
  end

  def setup_organization
    get_organization_data
    get_authorization_user
  end

  def sync_organization
    response = api.people.v2.people.get
    people = response["data"]
    return people
    # people.each do |person|
    #   id = person["id"]
    #   person = person["attributes"]
    # end
  end

  private
    def api
      PCO::API.new(url: API_URL, oauth_access_token: @oauth_token.token)
    end
end
