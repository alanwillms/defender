module Defender
  class Map
    GRASS_IMAGE = 'media/images/grass.png'
    MONSTER_SPAWNER_IMAGE = 'media/images/monster_spawner.png'
    DEFENDING_CITY_IMAGE = 'media/images/defending_city.png'

    PATH_START = 'S'
    PATH_END = 'G'
    PATH_OPEN = '.'
    PATH_BLOCKED = '#'
    PATH_RIGHT = '+'
    PATH_WRONG = 'x'

    def initialize(window)
      @window = window
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

    def columns
      @columns ||= @window.width.to_i / tile_size.to_i
    end

    def rows
      @rows ||= @window.height.to_i / tile_size.to_i
    end

    private

      def maze_solution
        @maze_path = maze
        find_path(0, 0)
        @maze_path
      end

      def find_path(row, column)
        # Outside maze?
        if row < 0 or row >= rows or column < 0 or column >= columns
          return false
        end

        # Is the goal?
        if @maze_path[row][column] == PATH_END
          return true
        end

        # Path open?
        if @maze_path[row][column] != PATH_OPEN
          return false
        end

        # Mark current path as right
        @maze_path[row][column] = PATH_RIGHT

        # If north path is right
        if find_path(row - 1, column)
          return true
        end

        # If east path is right
        if find_path(row, column + 1)
          return true
        end

        # If sotuh path is right
        if find_path(row + 1, column)
          return true
        end

        # If west path is right
        if find_path(row, column - 1)
          return true
        end

        # Mark current path as WRONG
        @maze_path[row][column] = PATH_WRONG

        return false
      end

      def maze
        if @maze
          return @maze
        end
        @maze = []
        for row in 0...rows do
          @maze.push([])
          for column in 0...columns do
            @maze[row].push(PATH_OPEN)
          end
        end
        @maze[0][0] = PATH_START
        @maze[rows - 1][columns - 1] = PATH_END
        @maze
      end

      def draw_floor
        for column in 0...columns do
          for row in 0...rows do
            x = get_x_for_column(column)
            y = get_y_for_row(row)
            z = ZOrder::Background

            get_tile.draw(x, y, z)
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
        x = get_x_for_column(columns - 1)
        y = get_y_for_row(rows - 1)
        z = ZOrder::Building
        tile.draw(x, y, z)
      end

      def tile_size
        @tile_size ||= get_tile.width
      end

      def get_tile
        @grass_tile ||= Gosu::Image.new(@window, GRASS_IMAGE, false)
      end
  end
end