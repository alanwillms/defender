module Defender
  class Map
    GRASS_IMAGE = 'media/images/grass.png'
    MONSTER_SPAWNER_IMAGE = 'media/images/monster_spawner.png'
    DEFENDING_CITY_IMAGE = 'media/images/defending_city.png'

    def initialize(window)
      @window = window
    end

    def draw
      draw_floor
      draw_monster_spawner
      draw_defending_city
    end

    private

      def draw_floor
        for column in 0...columns do
          for row in 0...rows do
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

      def draw_defending_city
        tile = Gosu::Image.new(@window, DEFENDING_CITY_IMAGE, false)
        x = (columns - 1) * tile_size
        y = (rows - 1) * tile_size
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