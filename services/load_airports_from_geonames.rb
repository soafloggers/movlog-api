# frozen_string_literal: true

# search rooms
class SearchAirports
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_airports
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

  register :search_airports, lambda { |location|
    airports = Geonames::AirportInfo.find(location).airports
    if airports.length.zero?
      Left(Error.new(:not_found, 'Flight not found'))
    else
      Right(airports.to_json)
    end
  }
end
