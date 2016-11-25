# frozen_string_literal: true

class SearchAirports
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  register :validate_params, lambda { |params|
    keyword = params[:keyword].gsub(/\+/, ' ')
    location = Location.find(name: keyword)

    if location
      Right(location)
    else
      Left(Error.new(:not_found, 'Location not found'))
    end
  }

  register :search_airports, lambda { |location|
    airports = Airport.where(location_id: location.id).all
    airports = airports.map do |loc|
      LocationRepresenter.new(loc).to_json
    end

    if airports
      Right(airports)
    else
      Left(Error.new(:not_found, 'Location not found'))
    end
  }

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_airports
    end.call(params)
  end
end
