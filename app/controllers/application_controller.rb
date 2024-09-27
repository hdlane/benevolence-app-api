CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class ApplicationController < ActionController::API
  before_action :require_login

  private
    def require_login
      unless session[:current_person_id]
        redirect_to("#{CLIENT_DOMAIN}/login", allow_other_host: true, status: :found)
      end
    end
end
