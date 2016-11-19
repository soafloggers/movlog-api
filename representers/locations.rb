# frozen_string_literal: true

# Represents overall group information for JSON API output
class LocationsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :locations, extend: LocationRepresenter, class: Location
end
