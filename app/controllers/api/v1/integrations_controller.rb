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
      oauth_token = oauth_token_creation.get_token(code: params[:code])
      pco_api = pco_api_sync(oauth_token)

      # create organization
      organization_data = pco_api.get_organization_data
      organization = Organization.create(organization_data)

      # create person that authenticated as first organization member
      person_data = pco_api.get_people_data(me = true)[0]
      person_data["organization_id"] = organization.id
      person = Person.create(person_data)

      redirect_to("#{CLIENT_DOMAIN}/login")
    end
  end

  def sync
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
      render json: { data: people_data, meta: { count: people_data.length } }
    else
      redirect_to("#{CLIENT_DOMAIN}/login")
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
