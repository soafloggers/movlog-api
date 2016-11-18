# frozen_string_literal: true

# Loads data from Facebook group to database
class FindMovie
  extend Dry::Monads::Either::Mixin

  def self.call(params)
    keyword = params[:keyword].gsub(/\+/, ' ')
    if (movie = Movie.find(title: keyword)).nil?
      Left(Error.new(:not_found, "Movie #{params[:keyword]} could not be found"))
    else
      Right(movie)
    end
  end
end
