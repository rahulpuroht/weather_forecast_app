class WeatherService
  def self.call(lat, long)
    api_key = Rails.application.credentials.open_weather_map_api_key
    weather_service_url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{long}&appid=#{api_key}&units=metric"
    begin
      weather_service_response = faraday_conn.get(weather_service_url)
        if weather_service_response.status == 200
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
  # create a Faraday connection.
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
