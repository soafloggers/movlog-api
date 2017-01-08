# frozen_string_literal: true

# search airports
class LoadAirportsFromGeonames
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :find_location
      step :retrieve_airports_from_geonames
      step :create_airports
    end.call(params)
  end

  register :validate_params, lambda { |location|
    begin
      search_terms = AirportsSearchCriteria.new(location)
      Right(search_terms)
    rescue
      Left(Error.new(:cannot_process, 'process params error'))
    end
  }

  register :find_location, lambda { |search_terms|
    location = Location.find(name: search_terms.location)
    if location.nil?
      Left(Error.new(:not_found, 'Location not found in DB'))
    else
      Right(search_terms: search_terms, location: location)
    end
  }

  register :retrieve_airports_from_geonames, lambda { |data|
    info = Airports::AirportInfo.find(data[:search_terms].proper_location)
    airports = info.airports
    if airports.length.zero?
      Left(Error.new(:not_found, 'Flight not found'))
    else
      Right(airports: airports, location: data[:location])
    end
  }

  register :create_airports, lambda { |data|
    begin
      data[:airports].each do |airport|
        unless find_airport(airport[:name], data[:location].id)
          write_airport(airport, data[:location])
        end
      end
      Right(data[:airports])
    rescue
      Left(Error.new(:not_found, 'Airports create failed'))
    end
  }

  private_class_method

  def self.write_airport(airport, location)
    Airport.create(
      name: airport[:name], country_code: airport[:country_code],
      lat: airport[:lat], lng: airport[:lng],
      location_id: location.id
    )
  end

  def self.find_airport(name, loc_id)
    Airport.find(name: name, location_id: loc_id)
  end
end
