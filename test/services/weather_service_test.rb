require "test_helper"
require "webmock/minitest"

class WeatherServiceTest < ActiveSupport::TestCase
  def setup
    @lat = 37.7749
    @long = -122.4194
    @api_key = Rails.application.credentials.open_weather_map_api_key
    @weather_url = "https://api.openweathermap.org/data/2.5/weather?lat=#{@lat}&lon=#{@long}&appid=#{@api_key}&units=metric"
  end

  test "returns weather data when API call is successful" do
    stub_request(:get, @weather_url)
      .to_return(status: 200, body: { "weather": [ { "description": "clear sky" } ], "main": { "temp": 22.0 } }.to_json, headers: { "Content-Type" => "application/json" })

    response = WeatherService.call(@lat, @long)
    assert_equal [ { "description" => "clear sky" } ], response["weather"]
assert_equal({ "temp" => 22.0 }, response["main"])
  end

  test "logs an error when API call fails" do
    stub_request(:get, @weather_url)
      .to_return(status: 500, body: { "error": "Internal Server Error" }.to_json)

    assert_output("Faraday error: the server responded with status 500\n") do
      response = WeatherService.call(@lat, @long)
      assert_nil response # Now it should return nil instead of raising an error
    end
  end

  test "handles connection failure" do
    stub_request(:get, @weather_url).to_raise(Faraday::ConnectionFailed.new("Failed to connect"))

    assert_output(/Faraday error/) do
      response = WeatherService.call(@lat, @long)
      assert_nil response
    end
  end

  test "handles unauthorized error (401)" do
    stub_request(:get, @weather_url)
      .to_return(status: 401, body: { "message": "Invalid API key" }.to_json)

    assert_output(/Faraday error/) do
      response = WeatherService.call(@lat, @long)
      assert_nil response
    end
  end
end
