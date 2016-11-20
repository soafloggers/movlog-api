# frozen_string_literal: true

# Loads data from Facebook group to database
class SearchLocations
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    keyword = params[:keyword].gsub(/\+/, ' ')
    movie = Movie.find(title: keyword)
    
    if movie
      Right(movie.id)
    else
      Left(Error.new(:not_found, 'Movie not found'))
    end
  }

  register :search_locations, lambda { |movie_id|
    locations = Location.where(movie_id: movie_id).all
    locations = locations.map do |loc|
      LocationRepresenter.new(loc).to_json
    end

    if locations
      Right(locations)
    else
      Left(Error.new(:not_found, 'Location not found'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_locations
    end.call(params)
  end
end
