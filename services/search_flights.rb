# frozen_string_literal: true

# search locations
class SearchFlights
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    if params[:outbound].nil? || params[:destination].nil?
      Left(Error.new(:bad_request, 'Parameters are wrong'))
    else
      params[:destination] = params[:destination].gsub(/\+/, ' ')
      Right(params)
    end
  }

  # register :validate_location, lambda { |data|
  #   location = Location.find(name: data[:destination])
  #   if location.nil?
  #     Left(Error.new(:not_found, 'Location not found'))
  #   else
  #     data[:destination] = "#{location.lat},#{location.lng}-Latlong"
  #     Right(data)
  #   end
  # }

  register :transform_to_geocode, lambda { |data|
    begin
      airport_info = Geonames::AirportInfo.find(data[:destination])
      data[:destination] = "#{airport_info.lat},#{airport_info.lng}-Latlong"
      Right(data)
    rescue
      Left(Error.new(:not_found, 'Location not found'))
    end
  }

  register :search_flights, lambda { |data|
    route_meta = {
      market: 'TW', currency: 'TWD', locale: 'zh-TW',
      origin: 'TW', destination: data[:destination],
      outbound: data[:outbound], inbound: 'anytime'
    }
    route = Skyscanner::Route.find(route_meta)
    flights = route.flights
    if flights.length.zero?
      Left(Error.new(:not_found, 'Flight not found'))
    else
      Right(flights.to_json)
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      # step :validate_location
      step :transform_to_geocode
      step :search_flights
    end.call(params)
  end
end
