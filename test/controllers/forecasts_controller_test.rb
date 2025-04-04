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

    test "should fetch weather data for valid city query" do
      CoordinateService.stub :call, { latitude: 37.7749, longitude: -122.4194, zip: "94103" } do
        WeatherService.stub :call, { condition: "Sunny", "coord": { "lon": 73.0351, "lat": 26.2968 }, "weather": [ { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01n" } ], "base": "stations", "main" =>  { "temp": 32.06, "feels_like": 29.85, "temp_min": 32.06, "temp_max": 32.06, "pressure": 1007, "humidity": 15, "sea_level": 1007, "grnd_level": 980 }, "visibility": 10000, "wind" => { "speed": 6.24, "deg": 241, "gust": 13.77 }, "clouds" => { "all": 0 }, "dt": 1743957070, "sys": { "country": "IN", "sunrise": 1743900814, "sunset": 1743945998 }, "timezone": 19800, "id": 1268865, "name": "Jodhpur", "cod" => 200 } do
          get root_url, params: { query: "Delhi" }
          assert_response :success
          assert assigns(:weather_data)
          assert_equal 200, assigns(:weather_data)["cod"]
          assert_equal "Sunny", assigns(:weather_data)[:condition]
        end
      end
    end

    test "should handle CoordinateService exceptions gracefully" do
      CoordinateService.stub :call, ->(_) { raise StandardError, "Service unavailable" } do
        get root_url, params: { query: "Delhi" }
        assert_response :success
        assert_equal "Service unavailable", flash[:alert]
      end
    end

    test "should handle query with only spaces" do
      get root_url, params: { query: "   " }
      assert_response :success
      assert_equal "Invalid Address.Enter City or Zipcode", flash[:alert]
    end


    test "should use cached weather data if available" do
      Rails.cache.write("94103", { temperature: 65, condition: "Cloudy" }, expires_in: 30.minutes)
      CoordinateService.stub :call, { latitude: 37.7749, longitude: -122.4194, zip: "94103" } do
        WeatherService.stub :call, { temperature: 65, condition: "Cloudy", "coord": { "lon": 73.0351, "lat": 26.2968 }, "weather": [ { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01n" } ], "base": "stations", "main" =>  { "temp": 32.06, "feels_like": 29.85, "temp_min": 32.06, "temp_max": 32.06, "pressure": 1007, "humidity": 15, "sea_level": 1007, "grnd_level": 980 }, "visibility": 10000, "wind" => { "speed": 6.24, "deg": 241, "gust": 13.77 }, "clouds" => { "all": 0 }, "dt": 1743957070, "sys": { "country": "IN", "sunrise": 1743900814, "sunset": 1743945998 }, "timezone": 19800, "id": 1268865, "name": "Jodhpur", "cod" => 200 } do
          get root_url, params: { query: "Delhi" }
          assert_response :success
          assert_equal false, assigns(:cache_exist)
          assert_equal 65, assigns(:weather_data)[:temperature]
          assert_equal "Cloudy", assigns(:weather_data)[:condition]
        end
      end
    end

    test "should handle query with special characters" do
        CoordinateService.stub :call, ->(_) { raise StandardError, "Address is not valid" } do
          get root_url, params: { query: "!@#$%^&*()" }
          assert_response :success
          assert_equal "Address is not valid", flash[:alert]
      end
    end

    test "should handle extremely long query" do
      CoordinateService.stub :call, ->(_) { raise StandardError, "Address is not valid" } do
        long_query = "a" * 500
        get root_url, params: { query: long_query }
        assert_response :success
        assert_equal "Address is not valid", flash[:alert]
      end
    end
  end
