class DefendingCity < Building
  attr_accessor :health_points

  def initialize(map, row, column)
    super(map, row, column)
    @health_points = 100
  end

  def monster_arrived?(monster)
    monster.current_row == @row and monster.current_column == @column
  end
end