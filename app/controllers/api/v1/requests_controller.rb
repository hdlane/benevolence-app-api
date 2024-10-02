class Api::V1::RequestsController < ApplicationController
  # GET /requests
  def index
    @requests = Request.where(organization_id: session[:organization_id])
    render json: @requests
  end

  # GET /requests/1
  def show
    @request = Request.find(params[:id])
    if session[:organization_id] == @request.organization_id
      render json: @request
    else
      render json: { errors: { status: 403, title: "Unauthorized", detail: "You do not have permission to access this resource" } }, status: 403
    end
  end

  # POST /requests
  def create
    if params[:request_data][:request_type] == "Donation"
      @request_builder = RequestCreation::DonationBuilder.new(params)
    elsif params[:request_data][:request_type] == "Meal"
      @request_builder = RequestCreation::MealBuilder.new(params)
    elsif params[:request_data][:request_type] == "Service"
      @request_builder = RequestCreation::ServiceBuilder.new(params)
    else
      render json: { errors: { status: 400, title: "Bad Request", detail: "Invalid parameters in call" } }, status: 400
    end
    @request = @request_builder.build_request
    @resources = @request_builder.build_resources
    if @request.save_request && @resources.save_resources
      render json: { status: :created }, status: :created
    else
      render json: { errors: { request: @request.get_errors, resources: @resources.get_errors } }, status: :unprocessable_entity
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
      render json: { errors: { status: 403, title: "Unauthorized", detail: "You do not have permission to access this resource" } }, status: 403
    end
  end

  # DELETE /requests/1
  def destroy
    @request = Request.find(params[:id])
    if session[:organization_id] == @request.organization_id
      @request.destroy!
    else
      render json: { errors: { status: 403, title: "Unauthorized", detail: "You do not have permission to access this resource" } }, status: 403
    end
  end

  private
    def request_params
      params.require(:request).permit(:person_id, :organization_id, :request_type, :title, :notes, :allergies, :start_date,
                                      :start_time, :end_date, :end_time, :street_line, :city, :state, :zip_code)
    end
end
