class CoordinateService
  def self.call(query)
    geocoder_response = Geocoder.search(query)
    raise "Address is not valid" unless geocoder_response && geocoder_response.any?
    coordinate_data = geocoder_response.first.data
    raise "Geo data not valid for given address" unless coordinate_data

    lat = sprintf("%0.04f", coordinate_data["lat"])
    long = sprintf("%0.04f", coordinate_data["lon"])
    coordinate_hash = { latitude: lat,
      longitude: long,
      display_name: coordinate_data["display_name"],
      zip: coordinate_data["address"]["postcode"],
      address: coordinate_data,
      city: coordinate_data["address"]["city"]
    }

    coordinate_hash
  end
end
