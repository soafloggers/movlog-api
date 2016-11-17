# frozen_string_literal: true

# Input for SearchMovie
class UrlRequestRepresenter < Roar::Decorator
  include Roar::JSON

  property :url
end
