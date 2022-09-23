require_relative '../cell'

module Box
end

class Box::Base
  attr_reader :cells, :grid_size

  def initialize(grid_size, result, locations)
    @grid_size = grid_size
    @result = result
    @cells = {}
    locations.each do |location|
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
