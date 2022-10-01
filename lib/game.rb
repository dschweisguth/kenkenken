require 'logger'
require_relative 'array'

class Game
  protected attr_reader :boxes

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
    resolve_boxes
    _solution
  end

  def _solution
    # All boxes are resolved when this method is called, so try to resolve partitions first.
    # Coordinating #solution, #guess and this method in this way is about 8% faster than
    # repeatedly resolving boxes and then partitions.
    loop { resolve_partitions && resolve_boxes || break }
    @logger.debug { "\n#{self.to_s.chomp}" }
    if a_box_is_unsolvable || a_row_is_unsolvable
      return nil
    end
    # Surprisingly, we don't also need to check for unsolvable columns,
    # not even to solve a transposed version of the game that requires checking for unsolvable rows
    if solved?
      return self
    end
    guessed_solution
  end

  private def resolve_boxes
    @boxes.inject(false) { |result, box| result | box.resolve }
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

  private def solvable?(row)
    Array.product(row.map(&:possibilities)).any? { |combo| combo.sort == all_digits }
  end

  def a_box_is_unsolvable
    @boxes.find { |box| !box.solvable? }.tap do |unsolvable_box|
      if unsolvable_box
        @logger.debug "Box #{unsolvable_box} is unsolvable"
      end
    end
  end

  def a_row_is_unsolvable
    @cells.find { |row| !solvable?(row) }.tap do |unsolvable_row|
      if unsolvable_row
        @logger.debug "Row #{unsolvable_row.map &:possibilities} is unsolvable"
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

  # One could imagine guessing boxes with the least combos first.
  # Not doing that is fast enough, so doing that isn't worthwhile.
  private def guessed_solution
    @boxes.lazy.with_index.
      flat_map { |box, box_index| box.guesses.map { |box_guess| [box_index, box_guess] } }.
      map { |box_index, box_guess| guess(box_index, box_guess).solution }.
      find &:itself
  end

  private def guess(box_index, box_guess)
    dup.tap do |copy|
      boxes = @boxes.map.with_index { |box, i| i == box_index ? box_guess : box.copy }
      copy.instance_variable_set '@boxes', boxes
      copy.initialize_cells
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
