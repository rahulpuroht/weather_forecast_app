class WeatherService
  # `WeatherService.call(lat, long)`:
  # - Accepts latitude (`lat`) and longitude (`long`) as arguments.
  # - Constructs the API URL using the provided coordinates and the API key.
  # - Makes an HTTP GET request to the OpenWeatherMap API using a Faraday connection.
  # - Handles errors gracefully by logging them and returning `nil` if an error occurs.
  # - Returns the weather data as a response body if the request is successful.
  def self.call(lat, long)
    api_key = Rails.application.credentials.open_weather_map_api_key
    # `weather_service_url`:
    # - Constructs the API endpoint URL dynamically using the provided latitude, longitude, and API key.
    # - Includes query parameters for metric units.
    weather_service_url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{long}&appid=#{api_key}&units=metric"
    begin
      # `weather_service_response`:
      # - Represents the HTTP response object returned by the Faraday connection.
      # - Contains the status code and response body of the API call.
      weather_service_response = faraday_conn.get(weather_service_url)
      if weather_service_response.status == 200
        # `weather_data`:
        # - Stores the parsed weather data if the API call is successful.
        weather_data = weather_service_response.body
      else
        puts "Error while fetching weather forecast"
      end
    rescue Faraday::Error => e
      puts "Faraday error: #{e.message}" # Log error instead of raising
      weather_data = nil
    end
    weather_data
  end
end

  # `faraday_conn`:
  # - Creates and configures a Faraday connection object.
  # - Sets request timeouts and response middleware for JSON parsing, error handling, and logging.
  # - Uses the `net_http` adapter for making HTTP requests.
  def faraday_conn
    @faraday ||= begin
      options = {
        request: {
          open_timeout: 1,
          read_timeout: 1,
          write_timeout: 1
        }
      }
      conn = Faraday.new(**options) do |config|
        config.response :json
        config.response :raise_error
        config.response :logger, Rails.logger, headers: true, bodies: true, log_level: :debug
        config.adapter :net_http
      end
    end
  end
