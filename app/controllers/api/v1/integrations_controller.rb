CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class Api::V1::IntegrationsController < ApplicationController
  def oauth
    url = oauth_token_creation.get_authorize_url
    redirect_to(url, allow_other_host: true)
  end

  def oauth_complete
    if params[:error]
      error = params[:error]
      error_description = params[:error_description]
      redirect_to("#{CLIENT_DOMAIN}/login?error=#{error}&error_description=#{error_description}")
    else
      oauth_token = oauth_token_creation.get_token(code = params[:code])
      pco_api = pco_api_sync(oauth_token.token, oauth_token.refresh_token)

      # create organization
      organization_data = pco_api.get_organization_data
      organization = Organization.create(organization_data)

      # create person that authenticated as first organization member
      person_data = pco_api.get_people_data(me = true)
      person_data[0]["organization_id"] = organization.id
      person = Person.create(person_data)

      redirect_to("#{CLIENT_DOMAIN}/login")
    end
  end

  def sync
    # get OAuth token from organization from current user
    organization = Organization.find(session[:organization_id])
    oauth_access_token = organization.access_token
    oauth_refresh_token = organization.refresh_token
    pco_api = pco_api_sync(oauth_access_token, oauth_refresh_token)

    # sync organization
    organization_data = pco_api.sync_organization
    if organization_data["name"] != organization.name
      organization.update(name: organization_data["name"])
    end

    # sync people
    people_data = pco_api.sync_people
    render json: { data: people_data }
  end

  private
    def oauth_token_creation
      OauthTokenCreation.new()
    end

    def pco_api_sync(oauth_access_token, oauth_refresh_token)
      PcoApiSync.new(oauth_access_token, oauth_refresh_token)
    end
end
