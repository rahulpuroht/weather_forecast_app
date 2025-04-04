class CoordinateService
  def self.call(query)
    geocoder_response = Geocoder.search(query)
    raise "Address is not valid" unless geocoder_response && geocoder_response.any?
    coordinate_data = geocoder_response.first.data
    raise "Geo data not valid for given address" unless coordinate_data

    lat = sprintf("%0.04f", coordinate_data["lat"])
    long = sprintf("%0.04f", coordinate_data["lon"])
    coordinate_hash = {
      latitude: lat, # Latitude of the location, formatted to 4 decimal places
      longitude: long, # Longitude of the location, formatted to 4 decimal places
      display_name: coordinate_data["display_name"], # Full display name of the location
      zip: coordinate_data["address"]["postcode"], # Postal code of the location
      address: coordinate_data, # Full address data as returned by the geocoder
      city: coordinate_data["address"]["city"] # City name extracted from the address
    }

    coordinate_hash
  end
end
