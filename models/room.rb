# frozen_string_literal: true

# Represents a Group's stored information
class Room < Sequel::Model
  many_to_one :location
end
