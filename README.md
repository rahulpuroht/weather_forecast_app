Weather Forecaster Application (Ruby on Rails)

Overview
This Ruby on Rails application provides weather forecasts based on user-inputted addresses. It integrates external APIs for weather data retrieval and implements caching to enhance performance and reduce redundant API calls.

Requirements:
  - Built using Ruby on Rails.
  - Accepts an address as input from the user.
  - Retrieves forecast data for the provided address, including at least the current temperature.
    - Bonus: Optionally fetch high/low temperatures and extended forecasts.
  - Displays the forecast details to the user in a user-friendly format.
  - Implements caching to store forecast details for 30 minutes, keyed by zip code.
  - Indicates in the UI when the displayed data is retrieved from the cache.

Ruby on Rails Version: 8.0.2  
Ruby Version: 3.3.1  

Setup
1. Initialize the Project
   - Create a new Rails application.
   - Use Bootstrap for responsive and modern styling.

2. Build the Controller
   - Generate a `forecasts_controller` to handle weather-related requests.
   - Write associated test cases in `test/controllers/forecasts_controller_test.rb`.
   - Implement flash messages for user notifications.

3. Forecast Retrieval
   - **Geocoding with Geocoder Gem**: Convert user-provided addresses into latitude and longitude using the Geocoder gem.
   - **WeatherService**: Develop a `WeatherService` class to fetch weather data from the OpenWeatherMap API using latitude and longitude.

4. API Request Handling with Faraday
   - Use the Faraday gem for making HTTP API requests, leveraging its flexibility and support for asynchronous processing.

5. Caching for Performance
   - Enable caching to store weather data for 30 minutes, reducing redundant API calls.
   - Display a clear indicator in the UI when the data is retrieved from the cache.

Conclusion
This weather forecasting application demonstrates best practices in Ruby on Rails development, including test-driven development (TDD), seamless API integration, and efficient caching mechanisms. It provides a reliable and user-friendly way to fetch and display weather data.

