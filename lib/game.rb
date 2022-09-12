require_relative 'box'

class Game
  def initialize(boxes)
    @boxes = boxes
    initialize_cells
    @size = @cells.length
    assert_grid_is_square
  end

  private def initialize_cells
    @cells = []
    @boxes.each do |box|
      box.cells.each do |(x, y), cell|
        @cells[y] ||= []
        if @cells[y][x]
          raise "Cell #{x}, #{y} is in more than one box"
        end
        @cells[y][x] = cell
      end
    end
  end

  private def assert_grid_is_square
    @cells.each_with_index do |row, y|
      if row.length != @size
        raise "Grid is #{@size} cells high but row #{y} is #{row.length} cells wide"
      end
    end
  end

  def solution
    self
  end

  def digits
    @cells.map { |row| row.map { |cell| cell.possibilities.length == 1 ? cell.possibilities.first : nil } }
  end
end
