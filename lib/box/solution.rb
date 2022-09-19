require_relative 'base'

class Box::Solution < Box::Base
  def solve
    @cells.first[1].restrict_to [@result]
  end
end
