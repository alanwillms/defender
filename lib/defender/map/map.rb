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
  end

  def draw
    for column in 0...@columns do
      for row in 0...@rows do
        x = MapHelper.get_x_for_column(column)
        y = MapHelper.get_y_for_row(row)
        z = ZOrder::Background

        SpriteHelper.image(:floor).draw(x, y, z)

        # Defense
        if @maze.matrix[row][column] == Maze::PATH_BLOCKED
          x = MapHelper.get_x_for_column(column)
          y = MapHelper.get_y_for_row(row)
          z = ZOrder::Building

          SpriteHelper.image(:defense).draw(x, y, z)
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

      at_monster_spawner = (clicked_row == 0 and clicked_column == 0)
      at_defending_city = (clicked_row == @last_row and clicked_column == @last_column)
      at_existing_defense = (@maze.matrix[clicked_row][clicked_column] == Maze::PATH_BLOCKED)
      blocks_path = @maze.block_all_paths?(clicked_row, clicked_column)
      blocks_monster = Window.current_window.current_screen.monster_spawner.block_any_monster_path?(clicked_row, clicked_column)

      DebugHelper.string("at_monster_spawner: #{at_monster_spawner.inspect}")
      DebugHelper.string("at_defending_city: #{at_defending_city.inspect}")
      DebugHelper.string("at_existing_defense: #{at_existing_defense.inspect}")
      DebugHelper.string("blocks_path: #{blocks_path.inspect}")
      DebugHelper.string("blocks_monster: #{blocks_monster.inspect}")

      if at_monster_spawner or at_defending_city or at_existing_defense or blocks_path or blocks_monster
        AudioHelper.play :cant_build
      else
        @maze.block(clicked_row, clicked_column)
        AudioHelper.play :defense_built
      end
    end
  end
end