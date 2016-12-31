# frozen_string_literal: true

# Represents overall room information for JSON API output
class AirportRepresenter < Roar::Decorator
  include Roar::JSON
  property :name
  property :country_code
  property :lat
  property :lng
end
