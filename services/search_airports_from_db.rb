# frozen_string_literal: true

# Search airports from database
class SearchAirportsFromDb
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :find_location
      step :find_airports
    end.call(params)
  end

  register :find_location, lambda { |loc_name|
    loc = Location.find(name: loc_name)
    if loc
      Right(loc)
    else
      Left(Error.new('Airport not found because location cannot be found!'))
    end
  }

  register :find_airports, lambda { |location|
    airports = Airport.where(location_id: location.id).all
    Right(airports)
  }
end
