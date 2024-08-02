require "test_helper"

class Api::V1::HandsControllerTest < ActionDispatch::IntegrationTest
  test "should get evaluate" do
    get api_v1_hands_evaluate_url
    assert_response :success
  end
end
