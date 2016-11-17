# frozen_string_literal: true

# Loads data from Facebook group to database
class FindMovie
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    if (movie = Movie.find(title: params[:keyword])).nil?
      Left(Error.new(:not_found, 'Movie not found'))
    else
      Right(movie)
    end
  end
end
