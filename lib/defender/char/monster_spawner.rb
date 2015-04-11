class MonsterSpawner
  attr_reader :monsters, :map, :x, :y

  def initialize(map)
    @map = map
    @monsters = Array.new
    @wave = 1
    @x = MapHelper.get_x_for_column(0)
    @y = MapHelper.get_y_for_row(0)
    @z = ZOrder::Building
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
    SpriteHelper.image(:monster_spawner).draw(@x, @y, @z)
  end

  private

    def spawn
      speed = rand(1..4)
      monster = Monster.new(@map.maze, speed)
      monster.warp(@x, @y)
      monster.find_target
      @monsters.push(monster)
      monster
    end
end