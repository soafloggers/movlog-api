# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_movie(:movie) do
      primary_key :imdb_id
      String :title
      String :actors
      String :plot
    end
  end
end
