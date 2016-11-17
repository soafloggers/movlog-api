# frozen_string_literal: true

# Represents a Group's stored information
class Movie < Sequel::Model
  one_to_many :locations
end
