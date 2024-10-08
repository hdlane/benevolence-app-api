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
  # TODO : Handle other missing params
  def create
    if REQUEST_TYPES.include? params[:request_data][:request_type]
      @request = RequestCreation.new(params)
    else
      render json: { errors: { message: "Bad Request", detail: "Invalid parameters in request" } }, status: :bad_request
    end

    @request = @request_builder.build_request
    if @request.save_request && @request.save_resources && @request.save_delivery_dates
      render json: { status: :created }, status: :created
    else
      render json: { errors: { request: @request.get_errors } }, status: :unprocessable_entity
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
    if session[:organization_id] == @request.organization_id
      @request.destroy!
    else
      render json: { errors: { message: "Forbidden", details: "You do not have permission to access this resource" } }, status: :forbidden
    end
  end

  private
    def request_params
      params.require(:request).permit(:person_id, :organization_id, :request_type, :title, :notes, :allergies, :start_date,
                                      :start_time, :end_date, :end_time, :street_line, :city, :state, :zip_code)
    end
end
