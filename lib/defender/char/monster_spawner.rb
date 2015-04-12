class MonsterSpawner < Building
  attr_reader :monsters, :map

  def initialize(map, row, column)
    super(map, row, column)
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

  private

    def spawn
      speed = rand(1..4)
      monster = Monster.new(@map.maze, speed)
      monster.warp(@row, @column)
      monster.find_target
      @map.monsters.push(monster)
      monster
    end
end