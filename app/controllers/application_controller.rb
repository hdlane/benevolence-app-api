CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class ApplicationController < ActionController::API
  before_action :require_login
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def not_found
    render plain: "Not found", status: :not_found
  end

  private
    def require_login
      unless session[:current_person_id]
        render json: { errors: { message: "Unauthorized", detail: "You must be logged in to access this resource" }, redirect_url: "#{CLIENT_DOMAIN}/login" }, status: :unauthorized
      end
    end

    def require_admin
      unless session[:is_admin] == true
        render json: { errors: { message: "Forbidden", detail: "You do not have permission to access this resource" } }, status: :forbidden
      end
    end

    def find_person_logged_in
      person_id = session[:current_person_id]
      if person_id
        @person_logged_in = Person.find(person_id)
        @is_admin = session[:is_admin]
      end
    end

    def parameter_missing(exception)
      render json: { errors: { message: "Bad Request", detail: "#{exception.message}" } }, status: :bad_request
    end
end
