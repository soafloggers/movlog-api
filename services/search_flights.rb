# frozen_string_literal: true

# search locations
class SearchFlights
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :transform_to_geocode
      step :search_flights
    end.call(params)
  end

  register :validate_params, lambda { |params|
    if params[:destination].nil? || params[:origin].nil?
      Left(Error.new(:bad_request, 'Parameters are wrong'))
    else
      params[:destination] = params[:destination].gsub(/\+/, ' ')
      params[:origin] = params[:origin].gsub(/\+/, ' ')
      Right(params)
    end
  }

  register :transform_to_geocode, lambda { |data|
    begin
      origin_info = Airports::AirportInfo.find(data[:origin])
      destin_info = Airports::AirportInfo.find(data[:destination])
      data[:origin] = sky_id(origin_info.lat, origin_info.lng)
      data[:destination] = sky_id(destin_info.lat, destin_info.lng)
      data[:outbound] = "anytime" if data[:outbound].nil?
      Right(data)
    rescue
      Left(Error.new(:not_found, 'Location not found'))
    end
  }

  register :search_flights, lambda { |data|
    route = Skyscanner::Route.find(route_meta(data))
    flights = route.flights.map {|flight| flight.to_hash}
    if flights.length.zero?
      Left(Error.new(:not_found, 'Flight not found'))
    else
      Right(flights.to_json)
    end
  }

  private_class_method

  def self.route_meta(params)
    route_meta = {
      market: 'TW', currency: 'TWD', locale: 'en-US',
      origin: params[:origin], destination: params[:destination],
      outbound: params[:outbound], inbound: 'anytime'
    }
  end

  def self.sky_id(lat, lng)
    "#{lat},#{lng}-Latlong"
  end
end
