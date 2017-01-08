# frozen_string_literal: true
require_relative 'airport'

# Represents overall room information for JSON API output
class AirportsSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :airports, extend: AirportRepresenter, class: Airport
end
