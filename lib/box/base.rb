require_relative '../cell'

module Box
end

class Box::Base
  attr_reader :cells, :grid_size

  def initialize(grid_size, result, locations)
    @grid_size = grid_size
    @result = result
    @cells = locations.map { |location| [location, Cell.new(self)] }.to_h
  end
end
