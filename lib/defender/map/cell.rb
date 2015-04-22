class Cell
  attr_reader :map, :row, :column

  def initialize(map, row, column)
    if row < 0 or column < 0
      raise ArgumentError.new "Row and column must be positive"
    end
    @map = map
    @row = row
    @column = column
  end

  def point
    @point ||= Point.new(
      MapHelper.get_x_for_column(@column),
      MapHelper.get_y_for_row(@row),
      0
    )
  end
end