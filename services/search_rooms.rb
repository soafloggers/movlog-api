# frozen_string_literal: true

# search rooms
class SearchRooms
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_params
      step :search_rooms
      step :return_results
    end.call(params)
  end

  register :validate_params, lambda { |params|
    begin
      location = params[:location].gsub(/\+/, ' ')
      Right(location)
    rescue
      Left(Error.new(:cannot_process, 'process params error'))
    end
  }

  register :search_rooms, lambda { |location|
    begin
      rooms_info = Airbnb::RoomsInfo.find(location: location)
      rooms = rooms_info.rooms.map do |room|
        RoomRepresenter.new(Room.new).from_json(room.to_json.to_s)
      end
      Right(location: location, rooms: rooms)
    rescue
      Left(Error.new(:cannot_process, 'search rooms failed'))
    end
  }

  register :return_results, lambda { |data|
    begin
      results = RoomsSearchResults.new(data[:location], data[:rooms])
      Right(results)
    rescue
      Left(Error.new(:cannot_process, 'result of rooms process failed'))
    end
  }
end
