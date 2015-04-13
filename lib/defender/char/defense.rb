class Defense < Building
  def initialize(map, row, column)
    super(map, row, column)
    @range = 4
    @cool_down_miliseconds = 3000
    @last_shot_at = nil
    @attack = 12
  end

  def monster_at_range?(monster)
    distance = MapHelper.euclidean_distance(center, monster.center)
    distance_in_tiles = distance / MapHelper.tile_size
    distance_in_tiles <= @range
  end

  def cooled_down?
    @last_shot_at.nil? or (@last_shot_at + @cool_down_miliseconds) < Gosu::milliseconds
  end

  def shoot!(monster)
    monster.health_points -= @attack
    if monster.health_points < 0
      monster.health_points = 0
    end
    DebugHelper.string("Monster: #{monster.health_points} / #{monster.initial_health_points}")
    @last_shot_at = Gosu::milliseconds
  end

  private
    def center
      half_tile = MapHelper.tile_size / 2
      x = MapHelper.get_x_for_column(@column)
      y = MapHelper.get_y_for_row(@row)
      [x + half_tile, y + half_tile]
    end
end