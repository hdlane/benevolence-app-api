REQUEST_TYPES ||= [ "Donation", "Meal", "Service" ]

class Api::V1::RequestsController < ApplicationController
  # GET /requests
  def index
    requests_data = RequestsDataTransformation.new(organization_id: session[:organization_id]).get_requests
    render json: { data: requests_data }
  end

  # GET /requests/1
  def show
    @request = Request.find(params[:id])
    if session[:organization_id] == @request.organization_id
      request_data = RequestsDataTransformation.new(request: @request).get_request
      render json: { data: request_data }
    else
      render json: { errors: { message: "Forbidden", detail: "You do not have permission to access this resource" } }, status: :forbidden
    end
  end

  # POST /requests
  def create
    if REQUEST_TYPES.include? params[:request][:request_type]
      begin
        request = RequestCreation.new(params, session)
        request.save_request
        request_id = request.get_id
        render json: { message: :created, id: request_id }, status: :created
      rescue RequestCreation::RequestSaveError => e
        logger.error "RequestSaveError: #{e.message}"
        logger.error e.backtrace.join("\n")
        render json: { errors: { message: "Bad Request", detail: "There was an error creating this request" } }, status: :bad_request
      rescue => e
        logger.error "Internal Server Error: #{e.message}"
        logger.error e.backtrace.join("\n")
        render json: { errors: { message: "Internal Server Error", detail: "An error has occurred on the server" } }, status: :internal_server_error
      end
    else
      render json: { errors: { message: "Bad Request", detail: "Invalid parameters in request" } }, status: :bad_request
    end
  end

  # PUT/PATCH /requests/1
  def update
    @request = Request.find(params[:id])
    if session[:organization_id] == @request.organization_id
      if @request.update(request_params)
        render json: @request
      else
        render json: @request.errors, status: :unprocessable_entity
      end
    else
      render json: { errors: { message: "Forbidden", detail: "You do not have permission to access this resource" } }, status: :forbidden
    end
  end

  # DELETE /requests/1
  def destroy
    @request = Request.find(params[:id])
    if session[:organization_id] == @request.organization_id && session[:is_admin] == true
      @request.destroy!
    else
      render json: { errors: { message: "Forbidden", details: "You do not have permission to access this resource" } }, status: :forbidden
    end
  end

  private
    def request_params
      params.require(:request).permit(:person_id, :organization_id, :request_type, :title, :notes, :allergies, :start_date,
                                      :end_date, :street_line, :city, :state, :zip_code)
    end
end
