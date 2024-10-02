require "test_helper"
require "date"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "should create request" do
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
      ]
    }

    @request_builder = RequestCreation::DonationBuilder.new(request_params)
    @request = @request_builder.build_request
    @resources = @request_builder.build_resources

  assert (@request.save_request && @resources.save_resources)
  end
end
