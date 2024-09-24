class DeliveryDatesController < ApplicationController
  # GET /delivery-dates
  def index
    @delivery_dates = DeliveryDate.all

    render json: @delivery_dates
  end

  # GET /delivery_dates/1
  def show
    render json: @delivery_date
  end

  # POST /delivery_dates
  def create
    @delivery_date = DeliveryDate.new(delivery_date_params)

    if @delivery_date.save
      render json: @delivery_date, status: :created, location: @delivery_date
    else
      render json: @delivery_date.errors, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /delivery_dates/1
  def update
    if @delivery_date.update(delivery_date_params)
      render json: @delivery_date
    else
      render json: @delivery_date.errors, status: :unprocessable_entity
    end
  end

  # DELETE /delivery_dates/1
  def destroy
    @delivery_date.destroy!
  end

  private
    def delivery_date_params
      params.require(:delivery_date).permit(:request_id, :resource_id, :date)
    end
end
