# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:locations) do
      primary_key :id
      foreign_key :movie_id
      String :name
      Float :lat
      Float :lng
    end
  end
end
