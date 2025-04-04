require "test_helper"

class ForecastsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get forecasts_search_url
    assert_response :success
  end
end
