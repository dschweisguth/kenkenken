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

  def copy
    dup.tap do |copy|
      cells = @cells.map do |location, old_cell|
        new_cell = Cell.new copy
        new_cell.possibilities.replace old_cell.possibilities
        [location, new_cell]
      end.to_h
      copy.instance_variable_set '@cells', cells
    end
  end
end
