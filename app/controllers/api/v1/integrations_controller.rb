class Api::V1::IntegrationsController < ApplicationController
  skip_before_action :require_login
  before_action :require_admin, only: [ :sync ]

  def oauth
    url = oauth_token_creation.get_authorize_url
    redirect_to(url, allow_other_host: true)
  end

  def oauth_complete
    begin
      if params[:error]
        error = params[:error]
        error_description = params[:error_description]
        render json: { errors: { message: "#{error}", detail: "#{error_description}" } }, status: :bad_request
      else
        # get oauth token for PCO account currently logged in with
        oauth_token = oauth_token_creation.get_token(code: params.require(:code))
        pco_api = pco_api_sync(oauth_token)

        organization_data = pco_api.get_organization_data
        existing_organization = Organization.find_by(pco_id: organization_data["pco_id"])
        if existing_organization
          existing_organization.update!(organization_data)
          person_data = pco_api.get_people_data(me = true)[0]
          existing_person = Person.find_by(pco_person_id: person_data["pco_person_id"])
          if !existing_person
            # create person that authenticated as first organization member
            person_data["organization_id"] = existing_organization.id
            person = Person.create!(person_data)
          end
        else
          # create organization
          organization = Organization.create!(organization_data)
          person_data = pco_api.get_people_data(me = true)[0]
          # create person that authenticated as first organization member
          person_data["organization_id"] = organization.id
          person = Person.create!(person_data)

          PersonMailer.with(person: person, person_name: person.first_name).organization_created.deliver_later
        end

        render json: { message: "Planning Center authorization complete", redirect_url: "#{CLIENT_DOMAIN}/login" }
      end
    rescue ActiveRecord::RecordNotUnique => e
        logger.error "Record already exists: #{e.message}"
        logger.error e.backtrace.join("\n")
        render json: { errors: { message: "Planning Center Authorization Error", detail: "Organization is already authorized with Benevolence App. Please login." } }, status: :conflict
    rescue => e
        logger.error "Error with Planning Center Authorization: #{e.message}"
        logger.error e.backtrace.join("\n")
        render json: { errors: { message: "Planning Center Authorization Error", detail: "An error has occurred during the integration with Planning Center: #{e.message}" } }, status: :internal_server_error
    end
  end

  def sync
    begin
      sync_token = token
      if sync_token
        pco_api = pco_api_sync(sync_token)
        # sync organization
        organization_sync_data = pco_api.sync_organization
        organization = Organization.find(session[:organization_id])
        if organization_sync_data["name"] != organization.name
          organization.update(name: organization_sync_data["name"])
        end

        # sync people
        people_data = pco_api.sync_people(organization.id)
        people_data_ids = people_data.map do |person|
          person["pco_person_id"]
        end
        Person.upsert_all(people_data, unique_by: :pco_person_id)
        Person.where(organization_id: organization.id).where.not(pco_person_id: people_data_ids).destroy_all
        render json: { message: "Planning Center sync complete", meta: { count: people_data.length } }
      else
        render json: { errors: { message: "No sync token available. Log back in", detail: "" } }, status: :internal_server_error
      end
    rescue => e
      logger.error "Error with Planning Center Sync: #{e.message}"
      logger.error e.backtrace.join("\n")
      render json: { errors: { message: "Planning Center Sync Error", detail: "An error has occurred during the sync with Planning Center" } }, status: :internal_server_error
    end
  end

  private
    def oauth_token_creation
      OauthTokenCreation.new()
    end

    def pco_api_sync(oauth_token)
      PcoApiSync.new(oauth_token)
    end

    def token
      if session[:organization_id].nil?
        return
      end
      organization = Organization.find(session[:organization_id])
      if organization.present?
        oauth_token = oauth_token_creation.get_token(organization: organization)
      end
      oauth_token
    end
end
