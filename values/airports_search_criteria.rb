# frozen_string_literal: true

# Input for SearchMovies
class AirportsSearchCriteria
  include WordMagic

  attr_accessor :location
  attr_accessor :sub_locations

  def initialize(location)
    @location = url_decode(location)
    @sub_locations = split_search_terms(@location)
  end

  def sub_term(n)
    final = sub_locations.length
    sub_locations[n...final].join(',')
  end

  def proper_location
    len = sub_locations.length
    if len <= 2
      @location
    elsif len < 5
      sub_term(len-2)
    else
      sub_term(len-3)
    end
  end
end
