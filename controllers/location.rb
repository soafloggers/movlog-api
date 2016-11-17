# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/:keyword/location/?" do
    results = SearchLocations.call(params)

    if results.success?
      LocationsSearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  put "/#{API_VER}/location/:id/:airport" do
    result = UpdateLocationFromImdb.call(params)

    if result.success?
      LocationRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
