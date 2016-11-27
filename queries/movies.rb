# frozen_string_literal: true

# Search query for movies by keywords
class MoviesQuery
  def self.call(search_terms)
    search_movies(search_terms)
  end

  private_class_method

  def self.search_movies(search_terms)
    Movie.where(where_clause(search_terms)).all
  end

  def self.where_clause(search_terms)
    search_terms.map do |term|
      Sequel.ilike(:title, "%#{term}%")
    end.inject(&:|)
  end
end
