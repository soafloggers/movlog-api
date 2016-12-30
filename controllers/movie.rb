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
    url_request = request.body.read
    channel_id = (headers.to_s + url_request.to_s).hash

    begin
      result = MovlogWorker.perform_async(
        {
          url_request: url_request,
          channel_id: channel_id
        }.to_json
      )
    rescue => e
      puts "ERROR: e"
    end
    puts "WORKER: #{result}"
    [202, { channel_id: channel_id }.to_json]
  end
end
