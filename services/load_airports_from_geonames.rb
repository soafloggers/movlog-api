# frozen_string_literal: true

# search rooms
class LoadAirportsFromGeonames
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :retrieve_airports_from_geonames
      step :create_airports
    end.call(params)
  end

  register :validate_params, lambda { |params|
    begin
      location = params[:location].gsub(/\+/, ' ')
      Right(location)
    rescue
      Left(Error.new(:cannot_process, 'process params error'))
    end
  }

  register :retrieve_airports_from_geonames, lambda { |location|
    airports = Geonames::AirportInfo.find(location).airports
    if airports.length.zero?
      Left(Error.new(:not_found, 'Flight not found'))
    else
      location = Location.find(name: location)
      Right(airports: airports, location: location)
    end
  }

  register :create_airports, lambda { |data|
    begin
      data['airports'].each do |airport|
        airport_model = write_airport(airport, data['location'])
      end
      Right(data['airports'].to_json)
    rescue
      Left(Error.new(:not_found, 'Airports create failed'))
    end
  }

  private_class_method

  def self.write_airport(airport, location)
    Airport.create(
      name: movie.imdb_id, country_code: movie.title,
      lat: movie.plot, lng: movie.rating,
      location_id: location.id
    )
  end
end
