module Defender
  class Monster
    SPRITE_FRAMES_COUNT = 3
    SPRITE_DOWN_POSITION = 0
    SPRITE_RIGHT_POSITION = 1
    SPRITE_UP_POSITION = 2
    SPRITE_LEFT_POSITION = 3

    attr_reader :x, :y

    def initialize(animation, x, y)
      @animation = animation
      @x = x
      @y = y
    end

    def draw
      img = @animation[Gosu::milliseconds / 100 % SPRITE_FRAMES_COUNT] # @animation.size
      img.draw(@x, @y, ZOrder::Character, 1, 1, color, :additive)
    end

    private
      def color
        unless @color
          @color = Gosu::Color.new(0xff000000)
          @color.red = rand(256 - 90) + 90
          @color.green = rand(256 - 90) + 90
          @color.blue = rand(256 - 90) + 90
        end
        @color
      end
  end
end