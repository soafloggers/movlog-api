# frozen_string_literal: true

# Loads data to database
class UpdateLocationFromImdb
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :find_location, lambda { |params|

    location_id = params[:id]
    airport = params[:airport]
    location = Location.find(id: location_id)
    if location
      Right(location: location, airport: airport)
    else
      Left(Error.new(:bad_request, 'Location is not stored'))
    end
  }

  register :update_location, lambda { |input|
    Right(update_location(input[:location], input[:airport]))
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :find_location
      step :update_location
    end.call(params)
  end

  private_class_method

  def self.update_location(location, airport)
    location.update(airport: airport)
    location.save
  end
end
