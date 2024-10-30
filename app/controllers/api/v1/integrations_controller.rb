CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class Api::V1::IntegrationsController < ApplicationController
  skip_before_action :require_login

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
        oauth_token = oauth_token_creation.get_token(code: params.require(:code))
        pco_api = pco_api_sync(oauth_token)

        # create organization
        organization_data = pco_api.get_organization_data
        organization = Organization.create!(organization_data)

        # create person that authenticated as first organization member
        person_data = pco_api.get_people_data(me = true)[0]
        person_data["organization_id"] = organization.id
        person = Person.create!(person_data)

        render json: { message: "Planning Center authorization complete", redirect_url: "#{CLIENT_DOMAIN}/login" }
      end
    rescue
        logger.error "Error with Planning Center Integration: #{e.message}"
        logger.error e.backtrace.join("\n")
        render json: { errors: { message: "Planning Center Integration Error", detail: "An error has occurred during the integration with Planning Center" } }, status: :internal_server_error
    end
  end

  def sync
    if !session[:is_admin]
      render json: { errors: { message: "Forbidden", details: "You do not have permission to access this resource" } }, status: :forbidden
    else
      sync_token = token
      if sync_token
        pco_api = pco_api_sync(sync_token)
        # sync organization
        organization_sync_data = pco_api.sync_organization
        organization = Organization.take(session[:organization_id])[0]
        if organization_sync_data["name"] != organization.name
          organization.update(name: organization_data["name"])
        end

        # sync people
        people_data = pco_api.sync_people(organization.id)
        people_data_ids = people_data.map do |person|
          person["pco_person_id"]
        end
        Person.upsert_all(people_data, unique_by: :pco_person_id)
        Person.where.not(pco_person_id: people_data_ids).destroy_all
        render json: { message: "Planning Center sync complete", meta: { count: people_data.length } }
      else
        render json: { errors: { message: "No sync token available. Log back in", detail: "" } }, status: :internal_server_error
      end
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
      organization = Organization.take(session[:organization_id])[0]
      if organization.present?
        oauth_token = oauth_token_creation.get_token(organization: organization)
      end
      oauth_token
    end
end
