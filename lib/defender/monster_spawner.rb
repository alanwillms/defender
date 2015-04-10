module Defender
  class MonsterSpawner
    attr_reader :monsters

    def initialize(map)
      @map = map
      @monsters = Array.new
    end

    def spawn
      monster = Monster.new(@map.get_x_for_column(0), @map.get_y_for_row(0))
      monster.set_destination(@map.get_x_for_column(@map.columns - 1), @map.get_y_for_row(@map.rows - 1))
      @monsters.push(monster)
      monster
    end

    def unspawn(monster)
      @monsters.delete monster
    end
  end
end