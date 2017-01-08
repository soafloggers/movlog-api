# frozen_string_literal: true

# Gets movie details from APIs
class SearchMovies
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_movies_from_db
      step :load_movies_from_omdb
      step :return_search_result
    end.call(params)
  end

  register :validate_params, lambda { |params|
    @params = params
    search_term = MoviesSearchCriteria.new(params)
    if search_term
      Right(search_term)
    else
      Left(Error.new(:cannot_process, 'Please enter movie title'))
    end
  }

  register :search_movies_from_db, lambda { |search_term|
    results = SearchMoviesFromDb.call(search_term)
    Right(search_term: search_term, db_results: results)
  }

  register :load_movies_from_omdb, lambda { |search_data|
    if not_found_in_db(search_data[:db_results])
      results = { omdb: send_msg_to_worker(
        search_data[:search_term].whole_term)
      }
    elsif search_data[:db_results].success?
      results = { db: search_data[:db_results].value }
    end
    Right(results)
  }

  register :return_search_result, lambda { |results|
    if results[:db]
      Right(MoviesSearchResultsRepresenter.new(results[:db]).to_json)
    elsif results[:omdb]
      Right([202, { channel_id: channel_id }.to_json])
    else
      Left(Error.new('Movie not found!'))
    end
  }

  private_class_method

  def self.channel_id
    return @channel_id if @channel_id
    @channel_id = (@params[:headers].to_s + @params[:search].to_s).hash
  end

  def self.send_msg_to_worker(term)
    result = MovlogWorker.perform_async(
      {
        search_term: term,
        channel_id: channel_id
      }.to_json
    )
  end

  def self.not_found_in_db(db_results)
    !db_results.success? || db_results.value.movies&.count.zero?
  end
end
