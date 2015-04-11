class Monster
  SPRITE_FRAMES_COUNT = 3
  SPRITE_DOWN_POSITION = 0
  SPRITE_RIGHT_POSITION = 1
  SPRITE_UP_POSITION = 2
  SPRITE_LEFT_POSITION = 3

  attr_reader :x, :y, :attack

  def initialize(spawner, speed)
    @spawner = spawner
    @speed = speed
    @x = @spawner.x
    @y = @spawner.y
    @target_x = 0
    @target_y = 0
    @attack = 10
    @facing = SPRITE_RIGHT_POSITION
  end

  def find_target
    set_target
    set_face
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

    def set_target
      current_row = MapHelper.get_row_for_y(@y)
      current_column = MapHelper.get_column_for_x(@x)
      next_row, next_column = *@spawner.map.maze.solution.next_position_for(current_row, current_column)
      @target_x = MapHelper.get_x_for_column(next_column)
      @target_y = MapHelper.get_y_for_row(next_row)
    end

    def set_face
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
end