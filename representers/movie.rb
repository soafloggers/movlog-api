# frozen_string_literal: true

# Represents overall group information for JSON API output
class MovieRepresenter < Roar::Decorator
  include Roar::JSON

  property :imdb_id
  property :title
  property :actors
  property :plot
end
