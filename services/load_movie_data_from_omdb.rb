# frozen_string_literal: true

# Loads data from Facebook group to database
class LoadMovieFromOmdb
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_request_json, lambda { |request_body|
    begin
      url_representation = UrlRequestRepresenter.new(UrlRequest.new)
      Right(url_representation.from_json(request_body))
    rescue
      Left(Error.new(:bad_request, 'URL could not be resolved'))
    end
  }

  register :validate_request_url, lambda { |body_params|
    if (fb_group_url = body_params['url']).nil?
      Left(:cannot_process, 'URL not supplied')
    else
      Right(fb_group_url)
    end
  }

  register :retrieve_omdb_movie_data, lambda { |omdb_url|
    begin
      omdb_movie_data = HTTP.get(omdb_url).body
      Right(omdb_movie_data)
    rescue
      Left(Error.new(:bad_request, 'URL could not be resolved'))
    end
  }

  register :parse_movie_title, lambda { |omdb_movie_data|
    begin
      ombd_movie = JSON.parse(omdb_movie_data)
      movie_title = ombd_movie['Title'].gsub(/ /, '+')
      Right(movie_title)
    else
      Left(Error.new(:cannot_process, 'Movie data cannot parse title'))
    end
  }

  register :retrieve_movie_and_locations_data, lambda { |movie_title|
    if Movie.find(title: movie_title)
      Left(Error.new(:cannot_process, 'Movie already exists'))
    else
      Right(Movlog::Movie.find(t: movie_title))
    end
  }

  register :create_movie_and_locations, lambda { |movlog_movie|
    movie = Movie.create(imdb_id: movlog_movie.imdb_id, title: movlog_movie.title,
                         actors: movlog_movie.actors, plot: movlog_movie.plot)
    locations = JSON.parse(movlog_movie.get_location)
    locations.each do |location|
      write_movie_location(movie, location)
    end
    Right(group)
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :validate_request_url
      step :retrieve_omdb_movie_data
      step :parse_movie_title
      step :retrieve_movie_and_locations_data
      step :create_movie_and_locations
    end.call(params)
  end

  private_class_method

  def self.write_movie_location(movie, location)
    movie.add_location(
      name:           name,
      airport:        'air'
    )
  end
end
