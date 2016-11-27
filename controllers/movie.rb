# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/movie/?" do
    results = SearchMovies.call(params)

    if results.success?
      MoviesSearchResultsRepresenter.new(results.value).to_json
    else
      ErrorRepresenter.new(results.value).to_status_response
    end
  end

  # Body args (JSON) e.g.: {"url": "http://www.omdbapi.com?t=star+wars&y=&plot=short&r=json"}
  post "/#{API_VER}/movie/?" do
    result = LoadMovieFromOmdb.call(request.body.read)

    if result.success?
      content_type 'application/json'
      MovieRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
