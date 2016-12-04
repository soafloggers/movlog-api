# frozen_string_literal: true

# Loads data to database
class UpdateLocationFromImdb
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :find_location, lambda { |params|
    location_id = params[:id]
    movie = params[:movie]
    location = Location.find(id: location_id)
    if location
      Right(location: location, movie: movie)
    else
      Left(Error.new(:bad_request, 'Location is not stored'))
    end
  }

  register :find_movie, lambda { |data|
    title = data[:movie].gsub(/\+/, " ")
    movie = Movie.find(title: title)

    if movie
      Right(location: data[:location], movie_id: movie.id)
    else
      Left(Error.new(:bad_request, 'Movie is not stored'))
    end
  }

  register :update_location, lambda { |data|
    Right(update_location(data[:location], data[:movie_id]))
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :find_location
      step :find_movie
      step :update_location
    end.call(params)
  end

  private_class_method

  def self.update_location(location, movie_id)
    location.update(movie_id: movie_id)
    location.save
  end
end
