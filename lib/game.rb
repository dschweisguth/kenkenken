require_relative 'box'

class Game
  def initialize(boxes)
    @boxes = boxes
    initialize_cells
  end

  private def initialize_cells
    @cells = []
    @boxes.each do |box|
      box.cells.each do |(x, y), cell|
        @cells[y] ||= []
        @cells[y][x] = cell
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
