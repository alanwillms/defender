class MonsterSpawner < Building
  attr_reader :monsters, :map

  def initialize(map, row, column)
    super(map, row, column, :monster_spawner)
  end

  def spawn_wave
    if has_preset_wave?(@map.wave)
      preset_wave(@map.wave).each do |type, quantity|
        quantity.times do
          spawn(type)
        end
      end
    else
      @map.wave.times { spawn }
    end
    @map.wave += 1
  end

  private

    def spawn(type = nil)
      monster = Monster.new(@map.maze, type)
      monster.warp(@row, @column)
      monster.find_target
      @map.monsters.push(monster)
      monster
    end

    def has_preset_wave?(current_wave)
      not Game.config[:waves][current_wave].nil?
    end

    def preset_wave(current_wave)
      Game.config[:waves][current_wave]
    end
end