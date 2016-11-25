# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/airport/:location/?" do
    results = SearchAirports.call(params)

    if results.success?
      content_type 'application/json'
      results.value.to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/airport/flight/:origin/:destination/:outbound/:inbound/?" do
    results = SearchFlights.call(params)

    if results.success?
      content_type 'application/json'
      results.value.to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  post "#{API_VER}/airport/?" do
    result = LoadAirportFromGeonames.call(request.body.read)

    if result.success?
      content_type 'application/json'
      result.value.to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  post "#{API_VER}/airport/flight/?" do
    result = LoadFlightFromGeonames.call(request.body.read)

    if result.success?
      content_type 'application/json'
      result.value.to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
