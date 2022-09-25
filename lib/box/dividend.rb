require_relative 'base'

class Box::Dividend < Box::Base
  def initialize(grid_size, result, locations)
    if locations.length != 2
      raise "locations must contain 2 locations, but contains #{locations.length}"
    end
    super
  end

  def satisfies_constraint?(combo)
    dividend_equals_result(combo[0], combo[1]) || dividend_equals_result(combo[1], combo[0])
  end

  private def dividend_equals_result(a, b)
    div, mod = a.divmod b
    div == @result && mod == 0
  end

  def operator
    '÷'
  end
end
