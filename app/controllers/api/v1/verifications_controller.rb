class VerificationsController < ApplicationController
  skip_before_action :require_login

  def verify_login_link
    token = params.require(:token)
    person = GlobalID::Locator.locate_signed(token)
    if person && person.is_a?(Person)
      # get all Organizations that match with person.email and send in json response
      session[:login_email] = person.email
      organizations_data = []
      matched_organizations = Organization.select(:id, :name).joins(:people).where(people: { email: person.email })
      matched_organizations.map do |organization|
        organizations_data.push(
          {
            "name" => organization.name,
            "id" => organization.id
          }
        )
      end
      render json: { data: organizations_data }
    end
    render json: { errors: { message: "Not Found", detail: "The resource you requested could not be found" } }, status: :not_found
  end

  def verify_organization
    # check params for selected Organization and send json response with
    # options to select Person then create session in verify_person
    people_data = []
    organization_id = params.require(:organization_id)
    person_email = session[:login_email]
    matched_people = Person.where(email: person_email).joins(:organization).where(organization: { id: organization_id })

    matched_people.map do |person|
      people_data.push(
        {
          "name" => person.name,
          "id" => person.id
        }
      )
    end
    render json: { data: people_data, message: "Login organization has been verified" }
  end

  def verify_person
    person_id = params.require(:person_id)
    person = Person.find(person_id)

    session[:current_person_id] = person.id
    session[:name] = person.name
    session[:organization_id] = person.organization_id
    session[:is_admin] = person.is_admin

    render json: { data: { id: person.id, name: person.name }, message: "Login successful", redirect_url: "#{CLIENT_DOMAIN}/" }
  end
end
