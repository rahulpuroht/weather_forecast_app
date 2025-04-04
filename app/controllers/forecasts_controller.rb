class ForecastsController < ApplicationController
  def search
    @query = params[:query]
    return if @query.nil?
    if @query.blank? # Validates address string and show message if address string is not valid
      flash.now[:alert] = "Invalid Address.Enter City or Zipcode"
    else
      # Retrieving data for proper input by user
      get_forecast_data
    end
  end

  private

  def get_forecast_data
    @res = CoordinateService.call(@query)
    # If in search zipcode is not passed or geocode not able to providethen make key with lat-long
    zipcode = @res[:zip] || "#{@res[:latitude]}--#{@res[:longitude]}"
    @cache_exist = Rails.cache.exist?(zipcode)
    @weather_data = Rails.cache.fetch(zipcode, expires_in: 30.minutes) do
      WeatherService.call(@res[:latitude], @res[:longitude])
    end
  rescue StandardError => e
    flash.now[:alert] = e.message # Error message if there is any exception
  end
end
