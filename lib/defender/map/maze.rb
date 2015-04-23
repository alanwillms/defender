class Maze
  PATH_START = :S
  PATH_END = :G
  PATH_OPEN = :"."
  PATH_BLOCKED = :"#"
  PATH_RIGHT = :"+"
  PATH_WRONG = :x
  PATH_GO_UP = :"↑"
  PATH_GO_RIGHT = :"→"
  PATH_GO_DOWN = :"↓"
  PATH_GO_LEFT = :"←"

  attr_reader :matrix, :map

  def initialize(map)
    @map = map
    @matrix = create_matrix
  end

  def create_solver(matrix, start_cell)
    start_row = start_cell.row
    start_column = start_cell.column
    MazeSolver.new(MapHelper.clone_matrix(matrix), start_row, start_column)
  end

  private
    def create_matrix
      matrix = MapHelper.create_matrix(@map.rows, @map.columns, PATH_OPEN)
      @map.defending_cities.each do |building|
        matrix[building.cell.row][building.cell.column] = PATH_END
      end
      matrix
    end
end