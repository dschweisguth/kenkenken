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
    resolve_constraints
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

  private def resolve_constraints
    loop do
      progressed = resolve_boxes | resolve_partitions
      break if !progressed
    end
  end

  private def resolve_boxes
    @boxes.inject(false) { |result, box| result | box.solve }
  end

  private def resolve_partitions
    _resolve_partitions(@cells) | _resolve_partitions(@cells.transpose)
  end

  private def _resolve_partitions(rows)
    rows.inject(false) do |progressed_in_rows, row|
      row.inject(progressed_in_rows) do |progressed_in_row, cell|
        subsets, not_subsets = row.partition { |other_cell| (other_cell.possibilities - cell.possibilities).empty? }
        if subsets.length == cell.possibilities.length
          complement = all_digits - cell.possibilities
          not_subsets.inject(progressed_in_row) do |progressed_in_cell, other_cell|
            progressed_in_cell | other_cell.restrict_to(complement)
          end
        else
          progressed_in_row
        end
      end
    end
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
