class Api::V1::AdministratorController < ApplicationController
  before_action :require_admin

  # GET /admin/overview
  def overview
    begin
      overview = AdminOverviewGeneration.new(session[:organization_id])
      overview_data = overview.generate_overview
      render json: { data: overview_data }
    rescue => e
      logger.error "Internal Server Error: #{e.message}"
      logger.error e.backtrace.join("\n")
      render json: { errors: { message: "Internal Server Error", detail: "An error has occurred on the server" } }, status: :internal_server_error
    end
  end
end
