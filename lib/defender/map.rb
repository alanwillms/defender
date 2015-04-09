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

    def get_x_for_column(column)
      column * tile_size
    end

    def get_y_for_row(row)
      row * tile_size
    end

    private

      def draw_floor
        for column in 0...columns do
          for row in 0...rows do
            x = get_x_for_column(column)
            y = get_y_for_row(row)
            z = ZOrder::Background

            get_tile.draw(x, y, z)
          end
        end
      end

      def draw_monster_spawner
        tile = Gosu::Image.new(@window, MONSTER_SPAWNER_IMAGE, false)
        x = get_x_for_column(0)
        y = get_y_for_row(0)
        z = ZOrder::Building
        tile.draw(x, y, z)
      end

      def draw_defending_city
        tile = Gosu::Image.new(@window, DEFENDING_CITY_IMAGE, false)
        x = get_x_for_column(columns - 1)
        y = get_y_for_row(rows - 1)
        z = ZOrder::Building
        tile.draw(x, y, z)
      end

      def tile_size
        @tile_size ||= get_tile.width
      end

      def get_tile
        @grass_tile ||= Gosu::Image.new(@window, GRASS_IMAGE, false)
      end

      def columns
        @columns ||= @window.width.to_i / tile_size.to_i
      end

      def rows
        @rows ||= @window.height.to_i / tile_size.to_i
      end
  end
end