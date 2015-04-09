module Defender
  class Map
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

          image = Gosu::Image.new(@window, "media/images/grass.png", false)
          image.draw(x, y, z)
        end
      end
    end

    private

      def tile_size
        @tile_size ||= Gosu::Image.new(@window, "media/images/grass.png", false).width
      end
  end
end