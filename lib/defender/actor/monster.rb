class Monster
  SPRITE_FRAMES_COUNT = 3
  SPRITE_DOWN_POSITION = 0
  SPRITE_LEFT_POSITION = 1
  SPRITE_RIGHT_POSITION = 2
  SPRITE_UP_POSITION = 3

  attr_reader :x, :y, :target_x, :target_y, :maze_solver, :facing, :current_row, :current_column, :initial_health_points, :money_loot
  attr_accessor :health_points, :speed

  def initialize(maze, type)
    @maze = maze
    @type = type
    @facing = SPRITE_RIGHT_POSITION
    @x = @y = @target_x = @target_y = @current_row = @current_column = 0
    @speed = rand(attributes[:speed]..attributes[:max_speed]) / 5
    @health_points = @initial_health_points = attributes[:life]
    @attack = attributes[:damage]
    @shield = attributes[:shield]
    @money_loot = attributes[:money] || 0
    update_maze_solver
  end

  def warp(cell)
    @x = cell.point.x
    @y = cell.point.y
    @current_row = cell.row
    @current_column = cell.column
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
    if target.health_points >= @attack
      target.health_points -= @attack
    else
      target.health_points = 0
    end
  end

  def draw
    identifier = 'monster_' + @type.to_s
    fixed_z = MapHelper.fix_z_for_row(ZOrder::Entity, @current_row)
    img = SpriteHelper.tiles(identifier.to_sym)[current_sprite]
    img.draw_rot(@x, @y, fixed_z, 0, 0, 0.5)
    HealthBar.new(@health_points, @initial_health_points, @x, @y - 16).draw
  end

  def center
    half_tile = MapHelper.tile_size / 2
    [@x + half_tile, @y + half_tile]
  end

  private

    def attributes
      Game.config[:monsters][@type]
    end

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
      start_cell = Cell.new(@maze.map, @current_row, @current_column)
      @maze_solver = @maze.create_solver(matrix, start_cell)
    end
end