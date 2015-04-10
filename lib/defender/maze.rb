module Defender
  class Maze
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

    attr_reader :matrix

    def initialize(rows, columns)
      @rows = rows
      @columns = columns
      @matrix = create_matrix
    end

    def path
      unless @maze_path
        @maze_path = @matrix
        find_path(0, 0)
      end
      @maze_path
    end

    private
      def create_matrix
        matrix = []
        for row in 0...@rows do
          matrix.push([])
          for column in 0...@columns do
            matrix[row].push(PATH_OPEN)
          end
        end
        matrix[@rows - 1][@columns - 1] = PATH_END
        matrix
      end

      def find_path(row, column)
        # Outside maze?
        if row < 0 or row >= @rows or column < 0 or column >= @columns
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
  end
end