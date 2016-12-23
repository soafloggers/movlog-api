# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/location/:keyword/?" do
    results = SearchLocations.call(params)

    if results.success?
      content_type 'application/json'
      LocationsSearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  put "/#{API_VER}/location/:id/:movie" do
    result = UpdateLocationFromImdb.call(params)

    if result.success?
      content_type 'application/json'
      LocationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  get "/#{API_VER}/room/:location/?" do
    puts params[:location]
    results = SearchRooms.call(params)

    if results.success?
      content_type 'application/json'
      RoomsSearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  get "/#{API_VER}/flight/:origin/:destination/:outbound/?" do
    results = SearchFlights.call(params)

    if results.success?
      content_type 'application/json'
      results.value.to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end
end
