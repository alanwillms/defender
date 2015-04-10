class Monster
  SPRITE_FRAMES_COUNT = 3
  SPRITE_DOWN_POSITION = 0
  SPRITE_RIGHT_POSITION = 1
  SPRITE_UP_POSITION = 2
  SPRITE_LEFT_POSITION = 3

  attr_reader :x, :y, :attack

  def initialize(speed, x, y)
    @speed = speed
    @x = x
    @y = y
    @target_x = 0
    @target_y = 0
    @attack = 10
    @facing = SPRITE_RIGHT_POSITION
  end

  def set_destination(x, y)
    @target_x = x
    @target_y = y
    if @x < @target_x
      @facing = SPRITE_RIGHT_POSITION
    elsif @x > @target_x
      @facing = SPRITE_LEFT_POSITION
    elsif @y < @target_y
      @facing = SPRITE_DOWN_POSITION
    elsif @y > @target_y
      @facing = SPRITE_UP_POSITION
    end
  end

  def move
    if @x < @target_x
      @x += @speed
    elsif @x > @target_x
      @x -= @speed
    elsif @y < @target_y
      @y += @speed
    elsif @y > @target_y
      @y -= @speed
    end
  end

  def draw
    img = SpriteHelper.tiles(:monster)[current_sprite] # @animation.size
    img.draw(@x, @y, ZOrder::Character, 1, 1)
  end

  private
    def current_sprite
      (Gosu::milliseconds / 100 % SPRITE_FRAMES_COUNT) + (@facing * SPRITE_FRAMES_COUNT)
    end
end