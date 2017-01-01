# frozen_string_literal: true

# search airports
class FuzzySearchAirports
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_airports_from_geonames
    end.call(params)
  end

  register :validate_params, lambda { |params|
    begin
      search_terms = AirportsSearchCriteria.new(params[:location])
      Right(search_terms)
    rescue
      Left(Error.new(:cannot_process, 'process params error'))
    end
  }

  register :search_airports_from_geonames, lambda { |search_terms|
    info = Airports::AirportInfo.find(search_terms.proper_location)
    airports = info.airports
    if airports.length.zero?
      Left(Error.new(:not_found, 'Airport not found'))
    else
      Right(airports)
    end
  }
end
