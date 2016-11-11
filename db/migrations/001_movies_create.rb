# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:movies) do
      primary_key :id
      String :title
      String :actors
      String :plot
    end
  end
end
