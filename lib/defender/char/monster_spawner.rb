class MonsterSpawner
  attr_reader :monsters

  def initialize(map)
    @map = map
    @monsters = Array.new
    @wave = 1
  end

  def spawn_wave
    for i in 0...@wave do
      spawn
    end
    @wave += 1
  end

  def unspawn(monster)
    @monsters.delete monster

    if @monsters.empty?
      spawn_wave
    end
  end

  def draw
    x = @map.get_x_for_column(0)
    y = @map.get_y_for_row(0)
    z = ZOrder::Building
    SpriteHelper.image(:monster_spawner).draw(x, y, z)
  end

  private

    def spawn
      speed = rand(1..4)
      monster = Monster.new(speed, @map.get_x_for_column(0), @map.get_y_for_row(0))
      monster.set_destination(@map.get_x_for_column(@map.columns - 1), @map.get_y_for_row(@map.rows - 1))
      @monsters.push(monster)
      monster
    end
end