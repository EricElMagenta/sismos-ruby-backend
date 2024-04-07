require "test_helper"

class EarthquakeControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get earthquake_new_url
    assert_response :success
  end
end
