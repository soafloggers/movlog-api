# frozen_string_literal: true
require_relative 'room'

# Represents overall room information for JSON API output
class RoomsSearchResultsRepresenter < Roar::Decorator
  include Roar::JSON

  property :location
  collection :rooms, extend: RoomRepresenter, class: Room
end
