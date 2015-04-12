class MonsterSpawner
  attr_reader :monsters, :map
  ROW = 0
  COLUMN = 0

  def initialize(map)
    @map = map
    @wave = 1
  end

  def spawn_wave
    for i in 0...@wave do
      spawn
    end
    @wave += 1
  end

  def unspawn(monster)
    @map.monsters.delete monster

    if @map.monsters.empty?
      spawn_wave
    end
  end

  def draw(x, y, z)
    SpriteHelper.image(:monster_spawner).draw(x, y, z)
  end

  private

    def spawn
      speed = rand(1..4)
      monster = Monster.new(@map.maze, speed)
      monster.warp(ROW, COLUMN)
      monster.find_target
      @map.monsters.push(monster)
      monster
    end
end