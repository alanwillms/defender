class Monster
  SPRITE_FRAMES_COUNT = 3
  SPRITE_DOWN_POSITION = 0
  SPRITE_RIGHT_POSITION = 2
  SPRITE_UP_POSITION = 3
  SPRITE_LEFT_POSITION = 1

  attr_reader :x, :y, :maze_solver, :current_row, :current_column, :initial_health_points, :money_loot
  attr_accessor :health_points

  def initialize(maze, type = nil)
    @maze = maze
    @type = type || random_type
    @facing = SPRITE_RIGHT_POSITION
    @x = @y = @target_x = @target_y = @current_row = @current_column = 0
    @maze_solver = update_maze_solver
    @last_maze_matrix = nil
    setup_attributes
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
    identifier = 'monster_' + @type.to_s
    fixed_z = MapHelper.fix_z_for_row(ZOrder::Entity, @current_row)
    img = SpriteHelper.tiles(identifier.to_sym)[current_sprite]
    img.draw(@x, @y - 16, fixed_z, 1, 1)
    HealthBar.new(@health_points, @initial_health_points, @x, @y - 16).draw
  end

  def center
    half_tile = MapHelper.tile_size / 2
    [@x + half_tile, @y + half_tile]
  end

  private

    def random_type
      self.class.types.keys.sample
    end

    def setup_attributes
      types = self.class.types
      @speed = rand(types[@type][:speed]..types[@type][:max_speed]) / 5
      @health_points = @initial_health_points = types[@type][:life]
      @attack = types[@type][:damage]
      @shield = types[@type][:shield]
      @money_loot = types[@type][:money] || 0
    end

    def self.types
      {
        weak_1: {
          speed: 3,
          max_speed: 10,
          life: 50,
          damage: 1,
          shield: 0,
          money: 5
        },
        weak_2: {
          speed: 6,
          max_speed: 20,
          life: 50,
          damage: 2,
          shield: 1
        },
        quick_1: {
          speed: 12,
          max_speed: 30,
          life: 50,
          damage: 3,
          shield: 1
        },
        big_hp: {
          speed: 5,
          max_speed: 10,
          life: 500,
          damage: 3,
          shield: 1
        },
        big_shield: {
          speed: 5,
          max_speed: 10,
          life: 50,
          damage: 3,
          shield: 20
        },
        big_damage: {
          speed: 7,
          max_speed: 14,
          life: 50,
          damage: 10,
          shield: 2
        },
        quick_big_hp: {
          speed: 15,
          max_speed: 30,
          life: 100,
          damage: 3,
          shield: 3
        },
        quick_2: {
          speed: 30,
          max_speed: 40,
          life: 30,
          damage: 4,
          shield: 1
        },
        big_hp_shield: {
          speed: 3,
          max_speed: 10,
          life: 300,
          damage: 5,
          shield: 15
        }
      }
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
      @maze_solver = @maze.create_solution(matrix, @current_row, @current_column)
    end
end