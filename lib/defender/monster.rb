module Defender
  class Monster
    SPRITE_FRAMES_COUNT = 3
    SPRITE_DOWN_POSITION = 0
    SPRITE_RIGHT_POSITION = 1
    SPRITE_UP_POSITION = 2
    SPRITE_LEFT_POSITION = 3

    SPEED = 1

    attr_reader :x, :y

    def initialize(animation, x, y)
      @animation = animation
      @x = x
      @y = y
      @target_x = 0
      @target_y = 0
    end

    def set_destination(x, y)
      @target_x = x
      @target_y = y
    end

    def move
      if @x < @target_x
        @x += SPEED
      elsif @x > @target_x
        @x -= SPEED
      end

      if @y < @target_y
        @y += SPEED
      elsif @y > @target_y
        @y -= SPEED
      end
    end

    def draw
      img = @animation[Gosu::milliseconds / 100 % SPRITE_FRAMES_COUNT] # @animation.size
      img.draw(@x, @y, ZOrder::Character, 1, 1)
    end
  end
end