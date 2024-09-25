require "pco_api"

API_URL ||= Rails.application.credentials.api_url
CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class Api::V1::IntegrationsController < ApplicationController
  def oauth
    url = oauth_token_creation.get_authorize_url
    redirect_to(url, allow_other_host: true)
  end

  def oauth_complete
    token = oauth_token_creation.get_token(params[:code])
    redirect_to(CLIENT_DOMAIN)
  end

  def sync
    token = params[:token]
    response = api(token).people.v2.people.get
    people = response["data"]
    people.each do |person|
      id = person["id"]
      person = person["attributes"]
    end
    render json: { data: people }
  end

  private
    def oauth_token_creation
      OauthTokenCreation.new()
    end

    def token
    end

    def api(token)
      PCO::API.new(url: API_URL, oauth_access_token: token)
    end
end
