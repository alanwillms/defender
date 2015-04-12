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

  def cell_blocked?(row, column)
    @matrix[row][column] == Maze::PATH_BLOCKED
  end

  def block(row, column)
    @matrix[row][column] = PATH_BLOCKED
  end

  def block_all_paths?(current_row, current_column)
    matrix = MapHelper.clone_matrix(@matrix)
    matrix[current_row][current_column] = PATH_BLOCKED
    not create_solution(matrix, MonsterSpawner::ROW, MonsterSpawner::COLUMN).has_solution?
  end

  def create_solution(matrix, start_row, start_column)
    MazeSolver.new(MapHelper.clone_matrix(matrix), start_row, start_column)
  end

  private
    def create_matrix
      matrix = MapHelper.create_matrix(@rows, @columns, PATH_OPEN)
      matrix[@rows - 1][@columns - 1] = PATH_END
      matrix
    end
end