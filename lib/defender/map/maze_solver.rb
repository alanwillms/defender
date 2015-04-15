class MazeSolver
  def initialize(matrix, starting_row, starting_column)
    @matrix = matrix
    @starting_row = starting_row
    @starting_column = starting_column
    @rows = @matrix.size
    @columns = @matrix[0].size
  end

  def solution
    unless @solved_path
      solve_path
    end
    @solved_path
  end

  def has_solution?
    has_solution = false
    for row in 0...@rows do
      for column in 0...@columns do
        current_cell = solution[row][column]
        if current_cell == Maze::PATH_GO_UP or current_cell == Maze::PATH_GO_DOWN or current_cell == Maze::PATH_GO_LEFT or current_cell == Maze::PATH_GO_RIGHT
          has_solution = true
          break
        end
      end
      break if has_solution
    end
    has_solution
  end

  def next_position_for(current_row, current_column)
    direction = solution[current_row][current_column]
    next_row = current_row
    next_column = current_column

    if direction == Maze::PATH_GO_UP
      next_row -= 1
    elsif direction == Maze::PATH_GO_DOWN
      next_row += 1
    elsif direction == Maze::PATH_GO_LEFT
      next_column -= 1
    elsif direction == Maze::PATH_GO_RIGHT
      next_column += 1
    end

    [next_row, next_column]
  end

  private
    def solve_path
      @solved_path = MapHelper.clone_matrix(@matrix)
      find_path(@starting_row, @starting_column)
      DebugHelper.matrix(@solved_path)
      reduce_path(@starting_row, @starting_column)
      DebugHelper.matrix(@solved_path)
      @solved_path
    end

    def is_direction?(value)
      value == Maze::PATH_GO_LEFT or value == Maze::PATH_GO_DOWN or value == Maze::PATH_GO_RIGHT or value == Maze::PATH_GO_UP
    end

    def reduce_path(row, column)
      current_path = @solved_path[row][column]

      if current_path != Maze::PATH_GO_LEFT and is_direction? @solved_path[row][column - 1]
        @solved_path[row][column] = Maze::PATH_GO_LEFT
        return reduce_path(row, column - 1)
      end

      if current_path != Maze::PATH_GO_DOWN and is_direction? @solved_path[row + 1][column]
        @solved_path[row][column] = Maze::PATH_GO_DOWN
        return reduce_path(row + 1, column)
      end

      if current_path != Maze::PATH_GO_RIGHT and is_direction? @solved_path[row][column + 1]
        @solved_path[row][column] = Maze::PATH_GO_RIGHT
        return reduce_path(row, column + 1)
      end

      if current_path != Maze::PATH_GO_UP and is_direction? @solved_path[row - 1][column]
        @solved_path[row][column] = Maze::PATH_GO_UP
        return reduce_path(row - 1, column)
      end
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