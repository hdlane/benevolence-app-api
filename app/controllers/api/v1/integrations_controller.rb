CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class Api::V1::IntegrationsController < ApplicationController
  def oauth
    url = oauth_token_creation.get_authorize_url
    redirect_to(url, allow_other_host: true)
  end

  def oauth_complete
    oauth_token = oauth_token_creation.get_token(params[:code])
    # Create Organization
    pco_api = pco_api_sync(oauth_token)
    organization_data = pco_api.get_organization_data
    organization = Organization.create(organization_data)

    # Create person that authenticated as first organization member
    person_data = pco_api.get_authorizing_user_data
    person_data["organization_id"] = organization.id
    person = Person.create(person_data)

    redirect_to("#{CLIENT_DOMAIN}/login")
  end

  def sync

    render json: { data: people }
  end

  private
    def oauth_token_creation
      OauthTokenCreation.new()
    end

    def pco_api_sync(oauth_token)
      PcoApiSync.new(oauth_token)
    end

    def token
    end
end
