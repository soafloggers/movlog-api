# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/flight/:destination/:outbound/?" do
    results = SearchFlights.call(params)

    if results.success?
      content_type 'application/json'
      results.value.to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

end
