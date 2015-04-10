module Defender
  class Map
    GRASS_IMAGE = 'media/images/grass.png'
    MONSTER_SPAWNER_IMAGE = 'media/images/monster_spawner.png'
    DEFENDING_CITY_IMAGE = 'media/images/defending_city.png'
    DEFENSE_IMAGE = 'media/images/defense.png'

    attr_reader :max_width, :max_height

    def initialize(window, max_width, max_height)
      @window = window
      @max_width = max_width
      @max_height = max_height
      @maze = Maze.new(rows, columns)
    end

    def draw
      draw_floor
      draw_monster_spawner
      draw_defending_city
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

    def set_next_destination_for(monster)
      monster_row = get_row_for_y(monster.y)
      monster_column = get_column_for_x(monster.x)
      next_row, next_column = *@maze.next_position_for(monster_row, monster_column)
      x = get_x_for_column(next_column)
      y = get_y_for_row(next_row)
      monster.set_destination(x, y)
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

        at_monster_spawner = clicked_row == 0 and clicked_column == 0
        at_defending_city = clicked_row == last_row and clicked_column == last_column

        unless at_monster_spawner or at_defending_city
          @maze.block(clicked_row, clicked_column)
        end
      end
    end

    private

      def draw_floor
        for column in 0...columns do
          for row in 0...rows do
            x = get_x_for_column(column)
            y = get_y_for_row(row)
            z = ZOrder::Background

            grass_tile.draw(x, y, z)

            # Defense
            if @maze.path[row][column] == Maze::PATH_BLOCKED
              x = get_x_for_column(column)
              y = get_y_for_row(row)
              z = ZOrder::Building

              defense_tile.draw(x, y, z)
            end
          end
        end
      end

      def draw_monster_spawner
        tile = Gosu::Image.new(@window, MONSTER_SPAWNER_IMAGE, false)
        x = get_x_for_column(0)
        y = get_y_for_row(0)
        z = ZOrder::Building
        tile.draw(x, y, z)
      end

      def draw_defending_city
        tile = Gosu::Image.new(@window, DEFENDING_CITY_IMAGE, false)
        x = get_x_for_column(last_column)
        y = get_y_for_row(last_row)
        z = ZOrder::Building
        tile.draw(x, y, z)
      end

      def tile_size
        @tile_size ||= grass_tile.width
      end

      def grass_tile
        @grass_tile ||= Gosu::Image.new(@window, GRASS_IMAGE, false)
      end

      def defense_tile
        @defense_tile ||= Gosu::Image.new(@window, DEFENSE_IMAGE, false)
      end
  end
end