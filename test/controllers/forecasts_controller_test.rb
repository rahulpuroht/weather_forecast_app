  require "test_helper"

  class ForecastsControllerTest < ActionDispatch::IntegrationTest
    test "should show alert for blank query" do
      get root_url, params: { query: "" }
      assert_response :success
      assert_equal "Invalid Address.Enter City or Zipcode", flash[:alert]
    end

    test "should handle errors gracefully" do
      Geocoder.stub :search, nil do
        get root_url, params: { query: "Invalid City" }
        assert_response :success
        assert_equal "Address is not valid", flash[:alert]
      end
    end
  end
