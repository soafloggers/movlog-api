# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/airports/:location" do
    results = SearchAirports.call(params)

    if results.success?
      content_type 'application/json'
      results.value
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  post "/#{API_VER}/airports/:location" do
    results = LoadAirportsFromGeonames.call(params)

    if results.success?
      content_type 'application/json'
      results.value
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/flights/:origin/:destination/:outbound/?" do
    results = SearchFlights.call(params)

    if results.success?
      content_type 'application/json'
      results.value
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
