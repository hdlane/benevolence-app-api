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

  def me
    person_id = session[:current_person_id]
    if person_id
      person = Person.find(person_id)
      data = {
        logged_in: true,
        is_admin: person.is_admin,
        name: person.name,
        id: person_id,
        organization_name: person.organization.name
      }
      person.is_admin ? data["synced_at"] = person.organization.synced_at : nil
      render json: data
    else
      reset_session
      render json: { errors: { message: "Unauthorized", detail: "Session has expired. Please login again." }, redirect_url: "#{CLIENT_DOMAIN}/login" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    render json: { message: "Logout successful", redirect_url: "#{CLIENT_DOMAIN}/login" }
  end

  private
    def login_link_creation(email, person)
      LoginLinkCreation.new(email, person)
    end
end
