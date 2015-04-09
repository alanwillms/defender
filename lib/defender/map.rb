module Defender
  class Map
    GRASS_TILE = 'media/images/grass.png'

    def initialize(window)
      @window = window
      @height = 14
      @width = 16
      @monster_spawner_point = [0, 0]
      @tower_point = [@width - 1, @height - 1]
    end

    def draw
      for column in 0..@width do
        for row in 0..@height do
          x = column * tile_size
          y = row * tile_size
          z = ZOrder::Background

          get_tile.draw(x, y, z)
        end
      end
    end

    private

      def tile_size
        @tile_size ||= get_tile.width
      end

      def get_tile
        Gosu::Image.new(@window, GRASS_TILE, false)
      end
  end
end