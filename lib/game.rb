class Game
  def initialize(boxes)
    @boxes = boxes
    initialize_cells
    @size = @cells.length
    @all_digits = (1..@size).to_a
    assert_grid_is_square
    assert_box_grid_sizes_match_grid
  end

  protected def initialize_cells
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

  private def assert_box_grid_sizes_match_grid
    @boxes.each do |box|
      if box.grid_size != @size
        raise "Grid size is #{@size}, but #{box} has grid size #{box.grid_size}"
      end
    end
  end

  def solution
    eliminate_possibilities
    if solved?
      return self
    end
    (0...@size).each do |y|
      (0...@size).each do |x|
        possibilities = @cells[y][x].possibilities
        if possibilities.length > 1
          possibilities.each do |possibility|
            solution = guess(x, y, possibility).solution
            if solution
              return solution
            end
          end
        end
      end
    end
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

  private def solved?
    @cells.all? { |row| row.map { |cell| cell.solution || 0 }.sort == @all_digits } &&
      (0...@size).all? { |x| @cells.map { |row| row[x].solution }.sort == @all_digits }
  end

  private def guess(x, y, digit)
    dup.tap do |copy|
      boxes = @boxes.map &:copy
      copy.instance_variable_set '@boxes', boxes
      copy.initialize_cells
      copy.instance_variable_get('@cells')[y][x].solution = digit
    end
  end

  def digits
    @cells.map { |row| row.map(&:solution) }
  end
end
