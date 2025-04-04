module ForecastsHelper
  def get_city
    @res[:city]
  end

  def get_zip
    @res[:zip]
  end

  def get_lat_long
    [ @res[:latitude], @res[:longitude] ]
  end

  def get_temp
    @weather_data[:main]
  end

  def display_name
    @res[:display_name]
  end
end
