class MazeSolver
  def initialize(matrix, starting_row, starting_column)
    @matrix = matrix
    @starting_row = starting_row
    @starting_column = starting_column
    # @matrix[@starting_row][@starting_column] = Maze::PATH_START
    @rows = @matrix.size
    @columns = @matrix[0].size
  end

  def solution
    unless @solved_path
      solve_path
      DebugHelper.matrix(@solved_path)
    end
    @solved_path
  end

  def next_position_for(current_row, current_column)
    next_step = solution[current_row][current_column]
    next_row = current_row
    next_column = current_column

    if next_step == Maze::PATH_GO_UP
      next_row -= 1
    elsif next_step == Maze::PATH_GO_DOWN
      next_row += 1
    elsif next_step == Maze::PATH_GO_LEFT
      next_column -= 1
    elsif next_step == Maze::PATH_GO_RIGHT
      next_column += 1
    end

    [next_row, next_column]
  end

  private
    def solve_path
      @solved_path = MapHelper.clone_matrix(@matrix)
      find_path(@starting_row, @starting_column)
      @solved_path
    end

    def find_path(row, column)
      # Outside maze?
      if row < 0 or row >= @rows or column < 0 or column >= @columns
        return false
      end

      # Is the goal?
      if @solved_path[row][column] == Maze::PATH_END
        return true
      end

      # Path open?
      if @solved_path[row][column] != Maze::PATH_OPEN
        return false
      end

      # Mark current path as right
      @solved_path[row][column] = Maze::PATH_RIGHT

      # If north path is right
      if find_path(row - 1, column)
        @solved_path[row][column] = Maze::PATH_GO_UP
        return true
      end

      # If east path is right
      if find_path(row, column + 1)
        @solved_path[row][column] = Maze::PATH_GO_RIGHT
        return true
      end

      # If south path is right
      if find_path(row + 1, column)
        @solved_path[row][column] = Maze::PATH_GO_DOWN
        return true
      end

      # If west path is right
      if find_path(row, column - 1)
        @solved_path[row][column] = Maze::PATH_GO_LEFT
        return true
      end

      # Mark current path as WRONG
      @solved_path[row][column] = Maze::PATH_WRONG

      return false
    end
end