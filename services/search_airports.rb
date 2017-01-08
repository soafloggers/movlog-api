# frozen_string_literal: true

# search airports
class SearchAirports
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_airports_from_db
      step :load_airports_from_geonames
      step :return_search_result
    end.call(params)
  end

  register :validate_params, lambda { |params|
    begin
      search_terms = AirportsSearchCriteria.new(params[:location])
      Right(search_terms)
    rescue
      Left(Error.new(:cannot_process, 'process params error'))
    end
  }

  register :search_airports_from_db, lambda { |search_term|
    results = SearchAirportsFromDb.call(search_term.location)
    if results.success? && results.value
      representer = AirportsSearchResultsRepresenter.new(
        AirportsSearchResults.new(results.value)
      )
      results = JSON.parse(representer.to_json)
    end
    Right(search_term: search_term, db_results: results['airports'])
  }

  register :load_airports_from_geonames, lambda { |search_data|
    if search_data[:db_results].length.zero?
      search_data[:geonames_results] = LoadAirportsFromGeonames.call(
        search_data[:search_term].location
      )
    end
    Right(search_data)
  }

  register :return_search_result, lambda { |search_data|
    if !search_data[:db_results].length.zero?
      Right(search_data[:db_results])
    elsif search_data[:geonames_results] &&
          search_data[:geonames_results].success?
      Right(search_data[:geonames_results].value)
    else
      Left(Error.new('Airport not found!'))
    end
  }
end
