class MonsterSpawner < Building
  attr_reader :monsters, :map

  def spawn_wave
    if has_preset_wave?(@map.wave)
      preset_wave(@map.wave).each do |type, quantity|
        quantity.times do
          spawn(type)
        end
      end
    else
      @map.wave.times { spawn(random_type) }
    end
    @map.wave += 1
  end

  private

    def spawn(type)
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

    def random_type
      Game.config[:monsters].keys.sample
    end
end