Weather Forecaster Application (Ruby on Rails)

Overview
This Ruby on Rails application provides weather forecasts based on user-inputted addresses. It integrates external APIs and implements caching for efficient performance.

Requirements:
  Must be done in Ruby on Rails
  Accept an address as input
  Retrieve forecast data for the given address. This should include, at minimum, the
  current temperature (Bonus points - Retrieve high/low and/or extended forecast)
  Display the requested forecast details to the user
  Cache the forecast details for 30 minutes for all subsequent requests by zip codes.
  Display indicator if result is pulled from cache.

RubyOnRails Version: 8.0.2
Ruby Version: 3.3.1

Setup
1. Initialize the Project
Create a new Rails application.

Use Bootstrap for styling.

2. Build the Controller
Generate forecasts_controller and write associated test cases in
test/controllers/forecasts_controller_test.rb.

Implement flash messages for notifications.

3. Forecast Retrieval
Geocoding with Geocoder Gem
Convert user-provided addresses into latitude & longitude using the Geocoder gem.

WeatherService
Develop a WeatherService to fetch weather data from OpenWeatherMap API using latitude & longitude.

4. API Request Handling with Faraday
Use Faraday for making HTTP API requests, leveraging its flexibility and support for asynchronous processing.

5. Caching for Performance
Enable caching to store weather data for 30 minutes.

Indicate in the UI when data is retrieved from the cache.

Conclusion
This weather forecasting app demonstrates best practices in Rails development, including TDD, API integration, and caching. It provides a reliable and efficient way to fetch and display weather data.

