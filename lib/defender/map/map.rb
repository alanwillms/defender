class Map
  attr_reader :max_width, :max_height, :maze, :rows, :columns, :last_row, :last_column

  def initialize(max_width, max_height)
    @max_width = max_width
    @max_height = max_height
    @columns = @max_width.to_i / MapHelper.tile_size
    @rows = @max_height.to_i / MapHelper.tile_size
    @last_column = @columns - 1
    @last_row = @rows - 1
    @maze = Maze.new(@rows, @columns)
    @buildings = MapHelper.create_matrix(@rows, @columns)
  end

  def build_random_walls
    # Random walls
    rand(1..(@rows*@columns/3)).times do
      row, column = *random_cell
      if can_build_at?(row, column)
        wall = Wall.new
        build_at!(wall, row, column)
      end
    end
  end

  def build_at!(object, row, column)
    @buildings[row][column] = object
    unless object.is_a?(MonsterSpawner) or object.is_a?(DefendingCity)
      @maze.block(row, column)
    end
  end

  def has_element_at?(row, column)
    @buildings[row][column].nil? == false
  end

  def draw
    for column in 0...@columns do
      for row in 0...@rows do
        x = MapHelper.get_x_for_column(column)
        y = MapHelper.get_y_for_row(row)

        SpriteHelper.image(:floor).draw(x, y, ZOrder::Background)

        unless @buildings[row][column].nil?
          @buildings[row][column].draw(x, y, ZOrder::Building)
        end
      end
    end
  end

  def monster_at_defending_city?(monster)
    monster_row = MapHelper.get_row_for_y(monster.y)
    monster_column = MapHelper.get_column_for_x(monster.x)
    monster_row == @last_row and monster_column == @last_column
  end

  def on_click(mouse_x, mouse_y)
    x1 = 0
    x2 = MapHelper.get_x_for_column(@last_column) + MapHelper.tile_size
    y1 = 0
    y2 = MapHelper.get_y_for_row(@last_row) + MapHelper.tile_size
    x_inside = (mouse_x >= x1 and mouse_x <= x2)
    y_inside = (mouse_y >= y1 and mouse_y <= y2)

    if x_inside and y_inside

      clicked_column = MapHelper.get_column_for_x(mouse_x.to_i)
      clicked_row = MapHelper.get_row_for_y(mouse_y.to_i)

      if clicked_column < 0 or clicked_column > @last_column or clicked_row < 0 or clicked_row > @last_row
        return
      end

      if can_build_at?(clicked_row, clicked_column)
        build_at!(Defense.new, clicked_row, clicked_column)
        AudioHelper.play :defense_built
      else
        AudioHelper.play :cant_build
      end
    end
  end

  private

    def random_cell
      [rand(0..@last_row), rand(0..@last_column)]
    end

    def can_build_at?(row, column)
      at_blocked_cell = has_element_at?(row, column)
      blocks_path = @maze.block_all_paths?(row, column)
      blocks_monster = (Window.current_window.current_screen.nil? == false and Window.current_window.current_screen.monster_spawner.block_any_monster_path?(row, column))

      DebugHelper.string("at_blocked_cell: #{at_blocked_cell.inspect}")
      DebugHelper.string("blocks_path: #{blocks_path.inspect}")
      DebugHelper.string("blocks_monster: #{blocks_monster.inspect}")

      not (at_blocked_cell or blocks_path or blocks_monster)
    end
end