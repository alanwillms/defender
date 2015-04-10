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
    PATH_GO_UP = '↑'
    PATH_GO_RIGHT = '→'
    PATH_GO_DOWN = '↓'
    PATH_GO_LEFT = '←'

    attr_reader :max_width, :max_height

    def initialize(window, max_width, max_height)
      @window = window
      @max_width = max_width
      @max_height = max_height
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
      @columns ||= @max_width.to_i / tile_size.to_i
    end

    def rows
      @rows ||= @max_height.to_i / tile_size.to_i
    end

    def set_next_destination_for(monster)
      # Current position
      monster_row = monster.y.to_i / tile_size.to_i
      monster_column = monster.x.to_i / tile_size.to_i

      # Maze
      next_step = maze_solution[monster_row][monster_column]
      next_row = monster_row
      next_column = monster_column

      if next_step == PATH_GO_UP
        next_row -= 1
      elsif next_step == PATH_GO_DOWN
        next_row += 1
      elsif next_step == PATH_GO_LEFT
        next_column -= 1
      elsif next_step == PATH_GO_RIGHT
        next_column += 1
      end

      # Next position
      x = get_x_for_column(next_column)
      y = get_y_for_row(next_row)
      monster.set_destination(x, y)
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
          @maze_path[row][column] = PATH_GO_UP
          return true
        end

        # If east path is right
        if find_path(row, column + 1)
          @maze_path[row][column] = PATH_GO_RIGHT
          return true
        end

        # If south path is right
        if find_path(row + 1, column)
          @maze_path[row][column] = PATH_GO_DOWN
          return true
        end

        # If west path is right
        if find_path(row, column - 1)
          @maze_path[row][column] = PATH_GO_LEFT
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