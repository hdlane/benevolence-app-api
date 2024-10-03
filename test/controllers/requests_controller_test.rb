require "test_helper"
require "date"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  test "should create donation request" do
    request_params = {
      "request_data": {
        "organization_id": 1,
        "recipient_id": 1,
        "coordinator_id": 3,
        "creator_id": 3,
        "request_type": "Donation",
        "title": "This is a test",
        "notes": "Call before dropping off",
        "allergies": nil,
        "start_date": Date.today,
        "end_date": Date.today,
        "start_time": Time.now,
        "end_time": Time.now + 500,
        "street_line": "1234 Main St",
        "city": "Norman",
        "state": "OK",
        "zip_code": "12345"
      },
      "resources_data": [
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Crayons",
          "kind": "Donation",
          "quantity": 20
        },
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Backpacks",
          "kind": "Donation",
          "quantity": 10
        }
      ],
      "selected_days": []
    }

    @good_donation_request = RequestCreation.new(request_params)

    assert (@good_donation_request.save_request && @good_donation_request.save_resources && @good_donation_request.save_delivery_dates)
  end

  test "should create meal request" do
    request_params = {
      "request_data": {
        "organization_id": 1,
        "recipient_id": 1,
        "coordinator_id": 3,
        "creator_id": 3,
        "request_type": "Meal",
        "title": "This is a test",
        "notes": "Call before dropping off",
        "allergies": "Bananas and Peanuts",
        "start_date": Date.today,
        "end_date": (Date.today + 13),
        "start_time": nil,
        "end_time": nil,
        "street_line": "1234 Main St",
        "city": "Norman",
        "state": "OK",
        "zip_code": "12345"
      },
      "resources_data": [],
      "selected_days": [ 1, 3, 5 ]
    }

    @good_meal_request = RequestCreation.new(request_params)

    assert (@good_meal_request.save_request && @good_meal_request.save_resources && @good_meal_request.save_delivery_dates)
  end

  test "should create service request" do
    request_params = {
      "request_data": {
        "organization_id": 1,
        "recipient_id": 1,
        "coordinator_id": 3,
        "creator_id": 3,
        "request_type": "Service",
        "title": "This is a test",
        "notes": "Call before dropping off",
        "allergies": nil,
        "start_date": Date.today,
        "end_date": Date.today,
        "start_time": Time.now,
        "end_time": Time.now + 500,
        "street_line": "1234 Main St",
        "city": "Norman",
        "state": "OK",
        "zip_code": "12345"
      },
      "resources_data": [
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Raking",
          "kind": "Service",
          "quantity": 2
        },
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Clean Gutters",
          "kind": "Service",
          "quantity": 1
        }
      ],
      "selected_days": []
    }

    @good_service_request = RequestCreation.new(request_params)

    assert (@good_service_request.save_request && @good_service_request.save_resources && @good_service_request.save_delivery_dates)
  end

  test "should not create donation request" do
    request_params = {
      "request_data": {
        "organization_id": 1,
        "recipient_id": 1,
        "coordinator_id": 3,
        "creator_id": 3,
        "request_type": "Donation",
        "title": "This is a test",
        "notes": "Call before dropping off",
        "allergies": nil,
        "start_date": Date.today,
        "end_date": Date.today,
        "start_time": Time.now,
        "end_time": Time.now + 500,
        "street_line": "1234 Main St",
        "city": "Norman",
        "state": "OK",
        "zip_code": "12345"
      },
      "resources_data": [
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Crayons",
          "kind": "Donation",
          "quantity": nil # <== quantity is required
        },
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Backpacks",
          "kind": "Donation",
          "quantity": 10
        }
      ],
      "selected_days": []
    }

    @bad_donation_request = RequestCreation.new(request_params)

    assert_not (@bad_donation_request.save_request && @bad_donation_request.save_resources && @bad_donation_request.save_delivery_dates)
  end

  test "should not create meal request" do
    request_params = {
      "request_data": {
        "organization_id": 1,
        "recipient_id": 1,
        "coordinator_id": 3,
        "creator_id": 3,
        "request_type": "Meal",
        "title": "This is a test",
        "notes": "Call before dropping off",
        "allergies": "Bananas and Peanuts",
        "start_date": Date.today,
        "end_date": (Date.today - 1), # <== end_date must be >= start_date
        "start_time": nil,
        "end_time": nil,
        "street_line": "1234 Main St",
        "city": "Norman",
        "state": "OK",
        "zip_code": "12345"
      },
      "resources_data": [],
      "selected_days": [ 1, 3, 5 ]
    }

    @bad_meal_request = RequestCreation.new(request_params)

    assert_not (@bad_meal_request.save_request && @bad_meal_request.save_resources && @bad_meal_request.save_delivery_dates)
  end

  test "should not create service request" do
    request_params = {
      "request_data": {
        "organization_id": 1,
        "recipient_id": 1,
        "coordinator_id": 3,
        "creator_id": 3,
        "request_type": "Service",
        "title": "This is a test",
        "notes": "Call before dropping off",
        "allergies": nil,
        "start_date": nil, # <== start_date is required
        "end_date": Date.today,
        "start_time": Time.now,
        "end_time": Time.now + 500,
        "street_line": "1234 Main St",
        "city": "Norman",
        "state": "OK",
        "zip_code": "12345"
      },
      "resources_data": [
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Raking",
          "kind": "Service",
          "quantity": 2
        },
        {
          "request_id": 3,
          "organization_id": 1,
          "name": "Clean Gutters",
          "kind": "Service",
          "quantity": 1
        }
      ],
      "selected_days": []
    }

    @bad_service_request = RequestCreation.new(request_params)

    assert_not (@bad_service_request.save_request && @bad_service_request.save_resources && @bad_service_request.save_delivery_dates)
  end
end
