class Monster
  SPRITE_FRAMES_COUNT = 3
  SPRITE_DOWN_POSITION = 0
  SPRITE_RIGHT_POSITION = 1
  SPRITE_UP_POSITION = 2
  SPRITE_LEFT_POSITION = 3

  attr_reader :x, :y, :maze_solver, :current_row, :current_column

  def initialize(maze, speed)
    @maze = maze
    @speed = speed
    @attack = 10
    @facing = SPRITE_RIGHT_POSITION
    @x = @y = @target_x = @target_y = @current_row = @current_column = 0
    @maze_solver = update_maze_solver
    @last_maze_matrix = nil
  end

  def warp(row, column)
    @x = MapHelper.get_x_for_column(column)
    @y = MapHelper.get_y_for_row(row)
    @current_row = row
    @current_column = column
    update_maze_solver
  end

  def find_target
    set_target
    set_face
  end

  def move
    unless move_y
      move_x
    end
  end

  def attack!(target)
    target.health_points -= @attack
  end

  def draw
    img = SpriteHelper.tiles(:monster)[current_sprite] # @animation.size
    img.draw(@x, @y, ZOrder::Character, 1, 1)
  end

  private
    def maze_changed?
      current_maze_matrix = @maze.matrix.inspect.to_sym
      if @last_maze_matrix.nil? or @last_maze_matrix != current_maze_matrix
        @last_maze_matrix = current_maze_matrix
        return true
      end
      false
    end

    def current_sprite
      (Gosu::milliseconds / 100 % SPRITE_FRAMES_COUNT) + (@facing * SPRITE_FRAMES_COUNT)
    end

    def set_target
      next_row, next_column = *@maze_solver.next_position_for(@current_row, @current_column)
      @target_x = MapHelper.get_x_for_column(next_column)
      @target_y = MapHelper.get_y_for_row(next_row)
    end

    def set_face
      if @y < @target_y
        @facing = SPRITE_DOWN_POSITION
      elsif @y > @target_y
        @facing = SPRITE_UP_POSITION
      elsif @x < @target_x
        @facing = SPRITE_RIGHT_POSITION
      elsif @x > @target_x
        @facing = SPRITE_LEFT_POSITION
      end
    end

    def move_x
      changed = false
      if @x < @target_x
        @x += @speed
        @x = @target_x if @x > @target_x
        changed = true
      elsif @x > @target_x
        @x -= @speed
        @x = @target_x if @x < @target_x
        changed = true
      end
      if @x == @target_x
        @current_column = MapHelper.get_column_for_x(@x)
        update_maze_solver if maze_changed?
      end
      changed
    end

    def move_y
      changed = false
      if @y < @target_y
        @y += @speed
        @y = @target_y if @y > @target_y
        changed = true
      elsif @y > @target_y
        @y -= @speed
        @y = @target_y if @y < @target_y
        changed = true
      end
      if @y == @target_y
        @current_row = MapHelper.get_row_for_y(@y)
        update_maze_solver if maze_changed?
      end
      changed
    end

    def update_maze_solver
      matrix = MapHelper.clone_matrix(@maze.matrix)
      @maze_solver = @maze.create_solution(matrix, @current_row, @current_column)
    end
end