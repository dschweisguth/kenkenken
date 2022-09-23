require_relative '../cell'

module Box
end

class Box::Base
  attr_reader :cells, :grid_size

  def initialize(grid_size, result, locations)
    @grid_size = grid_size
    @result = result
    initialize_cells(locations)
  end

  private def initialize_cells(locations)
    @cells = {}
    locations.each do |location|
      if location[0] < 0 || grid_size <= location[0]
        raise "Location #{location.inspect} x is off the grid"
      end
      if location[1] < 0 || grid_size <= location[1]
        raise "Location #{location.inspect} y is off the grid"
      end
      if @cells[location]
        raise "Two cells are at the same location, #{location.inspect}"
      end
      @cells[location] = Cell.new grid_size
    end
  end

  def copy
    dup.tap do |copy|
      copy.instance_variable_set '@cells', cells.transform_values(&:copy)
    end
  end
end
