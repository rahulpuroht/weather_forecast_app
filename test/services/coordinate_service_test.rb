require "test_helper"
require "minitest/mock"
require "ostruct"

class CoordinateServiceTest < ActiveSupport::TestCase
  def setup
    @valid_query = "Hyderabad"
    @invalid_query = "Invalid Address XYZ"
  end

  test "returns coordinate data when Geocoder returns valid results" do
    geocoder_response = [
      OpenStruct.new(data: {
        "lat" => 17.3850,
        "lon" => 78.4867,
        "display_name" => "Hyderabad, Telangana, India",
        "address" => { "postcode" => "500001", "city" => "Hyderabad" }
      })
    ]

    Geocoder.stub :search, geocoder_response do
      response = CoordinateService.call(@valid_query)

      assert_equal "17.3850", response[:latitude]
      assert_equal "78.4867", response[:longitude]
      assert_equal "Hyderabad, Telangana, India", response[:display_name]
      assert_equal "500001", response[:zip]
      assert_equal "Hyderabad", response[:city]
    end
  end

  test "raises error when address is invalid" do
    Geocoder.stub :search, [] do
      assert_raises(RuntimeError, "Address is not valid") do
        CoordinateService.call(@invalid_query)
      end
    end
  end

  test "raises error when Geocoder returns nil" do
    Geocoder.stub :search, nil do
      assert_raises(RuntimeError, "Address is not valid") do
        CoordinateService.call(@invalid_query)
      end
    end
  end

  test "raises error when coordinate data is missing" do
    geocoder_response = [ OpenStruct.new(data: nil) ]
    Geocoder.stub :search, geocoder_response do
      assert_raises(RuntimeError, "Geo data not valid for given address") do
        CoordinateService.call(@valid_query)
      end
    end
  end
end
