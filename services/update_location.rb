# frozen_string_literal: true

# Loads data to database
class UpdateLocationFromImdb
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :find_location, lambda { |params|
    location_id = params[:id]
    location = Location.find(id: location_id)
    if location
      Right(location)
    else
      Left(Error.new(:bad_request), 'Location is not stored')
    end
  }

  register :validate_location, lambda { |location|
    updated_data = Movlog::Movie.get_location
    if updated_data.nil?
      Left(Error.new(:not_found, 'Location not found anymore'))
    else
      Right(location: location, updated_data: updated_data)
    end
  }

  register :update_location, lambda { |input|
    Right(update_location(input[:location], input[:updated_data]))
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :find_location
      step :validate_location
      step :update_location
    end.call(params)
  end

  private_class_method

  def self.update_location(location, updated_data)
    location.update(airport: airport)
    location.save
  end
end
