class Map
  attr_reader :max_width, :max_height, :maze

  def initialize(max_width, max_height)
    @max_width = max_width
    @max_height = max_height
    @maze = Maze.new(rows, columns)
  end

  def draw
    for column in 0...columns do
      for row in 0...rows do
        x = get_x_for_column(column)
        y = get_y_for_row(row)
        z = ZOrder::Background

        SpriteHelper.image(:floor).draw(x, y, z)

        # Defense
        if @maze.path[row][column] == Maze::PATH_BLOCKED
          x = get_x_for_column(column)
          y = get_y_for_row(row)
          z = ZOrder::Building

          SpriteHelper.image(:defense).draw(x, y, z)
        end
      end
    end
  end

  def get_x_for_column(column)
    column * tile_size
  end

  def get_y_for_row(row)
    row * tile_size
  end

  def get_column_for_x(x)
    x.to_i / tile_size.to_i
  end

  def get_row_for_y(y)
    y.to_i / tile_size.to_i
  end

  def columns
    @columns ||= @max_width.to_i / tile_size.to_i
  end

  def rows
    @rows ||= @max_height.to_i / tile_size.to_i
  end

  def last_column
    columns - 1
  end

  def last_row
    rows - 1
  end

  def monster_at_defending_city?(monster)
    monster_row = get_row_for_y(monster.y)
    monster_column = get_column_for_x(monster.x)
    monster_row == last_row and monster_column == last_column
  end

  def on_click(mouse_x, mouse_y)
    x1 = get_x_for_column(0)
    x2 = get_x_for_column(last_column) + tile_size
    y1 = get_y_for_row(0)
    y2 = get_y_for_row(last_row) + tile_size
    x_inside = mouse_x >= x1 and mouse_x <= x2
    y_inside = mouse_y >= y1 and mouse_y <= y2

    if x_inside and y_inside
      clicked_column = get_column_for_x(mouse_x)
      clicked_row = get_row_for_y(mouse_y)

      at_monster_spawner = (clicked_row == 0 and clicked_column == 0)
      at_defending_city = (clicked_row == last_row and clicked_column == last_column)
      at_existing_defense = (@maze.path[clicked_row][clicked_column] == Maze::PATH_BLOCKED)
      blocks_path = @maze.block_all_paths?(clicked_row, clicked_column)

      if at_monster_spawner or at_defending_city or at_existing_defense or blocks_path
        AudioHelper.play :cant_build
      else
        @maze.block(clicked_row, clicked_column)
        AudioHelper.play :defense_built
      end
    end
  end

  private

    def tile_size
      @tile_size ||= SpriteHelper.image(:floor).width
    end
end