class MonsterSpawner
  attr_reader :monsters, :map, :x, :y
  ROW = 0
  COLUMN = 0

  def initialize(map)
    @map = map
    @monsters = Array.new
    @wave = 1
    @x = MapHelper.get_x_for_column(COLUMN)
    @y = MapHelper.get_y_for_row(ROW)
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
      monster.warp(ROW, COLUMN)
      monster.find_target
      @monsters.push(monster)
      monster
    end
end