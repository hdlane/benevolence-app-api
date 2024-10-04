CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class Api::V1::SessionsController < ApplicationController
  skip_before_action :require_login
  before_action :find_person_logged_in

  def login_link
    if @person_logged_in
        render json: { message: "Already logged in", redirect_url: "#{CLIENT_DOMAIN}/" }
    else
      email = params.require(:email)
      @person = Person.find_by(email: email)
      if @person
        login_link_creation(email, @person).create_login_link
        render json: { message: "Login link has been sent to #{email}" }
      else
        render json: { errors: { message: "Not Found", details: "The resource you requested could not be found" } }, status: :not_found
      end
    end
  end

  def create
  end

  def destroy
    reset_session
  end

  private
    def login_link_creation(email, person)
      LoginLinkCreation.new(email, person)
    end
end
