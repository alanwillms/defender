class MonsterSpawner < Building
  attr_reader :monsters, :map

  def initialize(map, row, column)
    super(map, row, column, :monster_spawner)
    @wave = 0
  end

  def spawn_wave
    if self.class.preset_waves[@wave]
      self.class.preset_waves[@wave].keys.each do |type|
        self.class.preset_waves[@wave][type].times do
          spawn(type)
        end
      end
    else
      @wave.times { spawn }
    end
    @wave += 1
  end

  private

    def spawn(type = nil)
      monster = Monster.new(@map.maze, type)
      monster.warp(@row, @column)
      monster.find_target
      @map.monsters.push(monster)
      monster
    end

    def self.preset_waves
      {
        0 => {weak_1: 1},
        1 => {weak_1: 1, weak_2: 1},
        2 => {weak_1: 2, weak_2: 1},
        3 => {weak_1: 2, weak_2: 1},
        4 => {weak_1: 3, weak_2: 2},
        5 => {weak_1: 4, weak_2: 2},
        6 => {weak_1: 5, weak_2: 3, quick_1: 2},
        7 => {weak_1: 6, weak_2: 4, quick_1: 1},
        8 => {weak_1: 7, weak_2: 3, quick_1: 2},
        9 => {weak_1: 8, weak_2: 4, quick_1: 3}
      }
    end
end