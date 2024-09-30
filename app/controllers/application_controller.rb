CLIENT_DOMAIN ||= Rails.application.credentials.client_domain

class ApplicationController < ActionController::API
  before_action :require_login

  private
    def require_login
      unless session[:current_person_id]
        redirect_to("#{CLIENT_DOMAIN}/login", allow_other_host: true, status: :found)
      end
    end

    def find_person_logged_in
      person_id = session[:current_person_id]
      if person_id
        @person_logged_in = Person.find(person_id)
        @is_admin = session[:is_admin]
      end
    end
end
