# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:airports) do
      primary_key :id
      foreign_key :location_id
      String :name
      String :country_code
      Float :lat
      Float :lng
    end
  end
end
