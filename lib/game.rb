require 'logger'

class Game
  def initialize(boxes)
    @logger = Logger.new(STDOUT).tap { |logger| logger.level = Logger::INFO }
    @boxes = boxes
    initialize_cells
    assert_grid_is_square
    assert_possibilities_match_grid
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
      if row.length != size
        raise "Grid is #{size} cells high but row #{y} is #{row.length} cells wide"
      end
    end
  end

  private def assert_possibilities_match_grid
    @boxes.each do |box|
      cell = box.cells.values.find { |cell| cell.possibilities.length != size }
      if cell
        raise "Grid size is #{size}, but a cell has #{cell.possibilities.length} possibilities"
      end
    end
  end

  def solution
    eliminate_possibilities
    @logger.debug { "\n#{self.to_s.chomp}" }
    unsolvable_box = @boxes.find { |box| !box.solvable? }
    if unsolvable_box
      @logger.debug "Box #{unsolvable_box} is unsolvable"
      return nil
    end
    if solved?
      return self
    end
    guessed_solution
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
    (0...size).each do |solved_x|
      (0...size).each do |solved_y|
        solution = @cells[solved_y][solved_x].solution
        if !solution
          next
        end
        (0...size).each do |unsolved_x|
          if unsolved_x == solved_x
            next
          end
          eliminated_something |= @cells[solved_y][unsolved_x].eliminate(solution)
        end
        (0...size).each do |unsolved_y|
          if unsolved_y == solved_y
            next
          end
          eliminated_something |= @cells[unsolved_y][solved_x].eliminate(solution)
        end
      end
    end
    eliminated_something
  end

  private def solved?
    [@cells, @cells.transpose].all? do |rows|
      rows.all? { |row| row.map { |cell| cell.solution || 0 }.sort == all_digits }
    end
  end

  private def all_digits
    @all_digits ||= (1..size).to_a
  end

  private def guessed_solution
    all_locations.
      lazy.
      flat_map { |x, y| @cells[y][x].unsolved_possibilities.map { |possibility| [x, y, possibility] } }.
      map { |x, y, possibility| guess(x, y, possibility).solution }.
      find &:itself
  end

  private def all_locations
    @all_locations ||= (0...size).to_a.product((0...size).to_a).map { |x, y| [y, x] }
  end

  private def guess(x, y, digit)
    dup.tap do |copy|
      boxes = @boxes.map &:copy
      copy.instance_variable_set '@boxes', boxes
      copy.initialize_cells
      copy.instance_variable_get('@cells')[y][x].restrict_to [digit]
    end
  end

  def digits
    @cells.map { |row| row.map(&:solution) }
  end

  private def size
    @size ||= @cells.length
  end

  def to_s
    @cells.
      reverse.
      map do |row|
        "#{row.map { |cell| cell.possibilities.inspect }.join ' '}\n"
      end.
      join
  end
end
