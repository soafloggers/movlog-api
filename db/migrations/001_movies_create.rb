# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:movies) do
      primary_key :id
      String :imdb_id
      String :title
      String :poster
      String :rating
      String :awards
      String :runtime
      String :director
      String :actors
      String :plot
      String :year
      String :released
      String :genre
    end
  end
end
