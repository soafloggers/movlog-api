# frozen_string_literal: true

# Represents a Group's stored information
class Location < Sequel::Model
  one_to_many :rooms
  one_to_many :airports
  many_to_one :movie
  many_to_many :flights
end
