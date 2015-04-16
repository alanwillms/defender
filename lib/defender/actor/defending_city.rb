class DefendingCity < Building
  attr_accessor :health_points, :initial_health_points

  def monster_arrived?(monster)
    monster.current_row == @row and monster.current_column == @column
  end

  def draw
    super
    HealthBar.new(@health_points, @initial_health_points, x, y).draw
  end
end