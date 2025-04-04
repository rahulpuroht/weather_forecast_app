class ForecastsController < ApplicationController
  # Handles the search functionality for weather forecasts.
  def search
    @query = params[:query] # User input for city or zipcode.
    return if @query.nil? # Exit if no query is provided.

    if @query.blank? # Validates address string and shows a message if invalid.
      flash.now[:alert] = "Invalid Address. Enter City or Zipcode"
    else
      # Retrieves weather data for valid input.
      get_forecast_data
    end
  end

  private

  # Retrieves forecast data based on the query.
  def get_forecast_data
    @res = CoordinateService.call(@query)
    # CoordinateService: Converts the query into latitude, longitude, and a zipcode.

    # Creates a cache key using zipcode or latitude-longitude if zipcode is unavailable.
    zipcode = @res[:zip] || "#{@res[:latitude]}--#{@res[:longitude]}"
    @cache_exist = Rails.cache.exist?(zipcode) # Checks if data is already cached.

    # Fetches weather data from cache or calls WeatherService if not cached.
    @weather_data = Rails.cache.fetch(zipcode, expires_in: 30.minutes) do
      WeatherService.call(@res[:latitude], @res[:longitude])
      # WeatherService: Fetches weather data using latitude and longitude.
    end
  rescue StandardError => e
    # Handles exceptions and displays an error message.
    flash.now[:alert] = e.message
  end
end
