class MonsterSpawner < Building
  attr_reader :monsters, :map

  def initialize(map, row, column)
    super(map, row, column, :monster_spawner)
    @wave = 1
  end

  def spawn_wave
    for i in 0...@wave do
      spawn
    end
    @wave += 1
  end

  private

    def spawn
      monster = Monster.new(@map.maze, Monster.random_type)
      monster.warp(@row, @column)
      monster.find_target
      @map.monsters.push(monster)
      monster
    end
end