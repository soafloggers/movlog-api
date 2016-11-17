# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:rooms) do
      primary_key :id
      String :name
      String :city
      String :picture_url
      # Int :person_capacity
      # Int :star_rating
      # Int :nightly_price
    end
  end
end
