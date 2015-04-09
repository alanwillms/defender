module Defender
  class Map
    GRASS_IMAGE = 'media/images/grass.png'
    MONSTER_SPAWNER_IMAGE = 'media/images/monster_spawner.png'

    def initialize(window)
      @window = window
      # @monster_spawner_point = [0, 0]
      # @tower_point = [columns - 1, rows - 1]
    end

    def draw
      draw_floor
      draw_monster_spawner
    end

    private

      def draw_floor
        for column in 0..columns do
          for row in 0..rows do
            x = column * tile_size
            y = row * tile_size
            z = ZOrder::Background

            get_tile.draw(x, y, z)
          end
        end
      end

      def draw_monster_spawner
        tile = Gosu::Image.new(@window, MONSTER_SPAWNER_IMAGE, false)
        x = 0
        y = 0
        z = ZOrder::Building
        tile.draw(x, y, z)
      end

      def tile_size
        @tile_size ||= get_tile.width
      end

      def get_tile
        Gosu::Image.new(@window, GRASS_IMAGE, false)
      end

      def columns
        @columns ||= @window.width.to_i / tile_size.to_i
      end

      def rows
        @rows ||= @window.height.to_i / tile_size.to_i
      end
  end
end