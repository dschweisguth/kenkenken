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
      @cells[location] = Cell.new(self)
    end
  end

  def copy
    dup.tap do |copy|
      cells = @cells.map do |location, old_cell|
        new_cell = Cell.new copy
        new_cell.instance_variable_set '@possibilities', old_cell.possibilities.dup
        [location, new_cell]
      end.to_h
      copy.instance_variable_set '@cells', cells
    end
  end
end
