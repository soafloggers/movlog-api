# frozen_string_literal: true

# Represents a Group's stored information
class Airport < Sequel::Model
  many_to_one :locations
end
