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
    eliminate_possibilities
    self
  end

  private def eliminate_possibilities
    loop do
      eliminated_something = eliminate_possibilities_with_boxes | eliminate_possibilities_with_cells
      break if !eliminated_something
    end
  end

  private def eliminate_possibilities_with_boxes
    @boxes.inject(false) { |result, box| result | box.solve }
  end

  private def eliminate_possibilities_with_cells
    eliminated_something = false
    (0...@size).each do |solved_x|
      (0...@size).each do |solved_y|
        solution = @cells[solved_y][solved_x].solution
        if !solution
          next
        end
        (0...@size).each do |unsolved_x|
          if unsolved_x == solved_x
            next
          end
          eliminated_something |= @cells[solved_y][unsolved_x].possibilities.delete(solution)
        end
        (0...@size).each do |unsolved_y|
          if unsolved_y == solved_y
            next
          end
          eliminated_something |= @cells[unsolved_y][solved_x].possibilities.delete(solution)
        end
      end
    end
    eliminated_something
  end

  def digits
    @cells.map { |row| row.map(&:solution) }
  end
end
