# frozen_string_literal: true

# MovlogAPI web service
class MovlogAPI < Sinatra::Base
  get "/#{API_VER}/:keyword/movie/?" do
    result = FindMovie.call(params)

    if result.success?
      MovieRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

  # Body args (JSON) e.g.: {"url": "http://www.omdbapi.com?t=star+wars&y=&plot=short&r=json"}
  post "/#{API_VER}/movie/?" do
    result = LoadMovieFromOmdb.call(request.body.read)

    if result.success?
      MovieRepresenter.new(result.value).to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
