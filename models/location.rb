# frozen_string_literal: true

# Represents a Group's stored information
class Location < Sequel::Model
  one_to_many :rooms
  many_to_one :movie
end
