# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_location(:location) do
      primary_key :id
      foreign_key :movie_id
      String :name
      String :airport
    end
  end
end
