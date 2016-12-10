# frozen_string_literal: true

# Represents overall room information for JSON API output
class RoomRepresenter < Roar::Decorator
  include Roar::JSON
  property :city
  property :name
  property :pic_url
  property :id
  property :person_capacity
  property :primary_host
  property :star_rating
  property :listing_currency
  property :nightly_price
end
