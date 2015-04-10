class DefendingCity
  attr_accessor :health_points

  def initialize(map)
    @health_points = 10
    @map = map
  end

  def draw
    x = MapHelper.get_x_for_column(@map.last_column)
    y = MapHelper.get_y_for_row(@map.last_row)
    z = ZOrder::Building
    SpriteHelper.image(:defending_city).draw(x, y, z)
  end
end