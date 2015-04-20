describe MazeSolver do
  context "#solution" do
    it "returns the maze solution" do
      maze = [
        [Maze::PATH_OPEN, Maze::PATH_OPEN, Maze::PATH_OPEN],
        [Maze::PATH_OPEN, Maze::PATH_OPEN, Maze::PATH_OPEN],
        [Maze::PATH_OPEN, Maze::PATH_OPEN, Maze::PATH_OPEN],
        [Maze::PATH_OPEN, Maze::PATH_OPEN, Maze::PATH_END]
      ]
      solution = [
        [Maze::PATH_GO_RIGHT, Maze::PATH_GO_RIGHT, Maze::PATH_GO_DOWN],
        [Maze::PATH_OPEN, Maze::PATH_OPEN, Maze::PATH_GO_DOWN],
        [Maze::PATH_OPEN, Maze::PATH_OPEN, Maze::PATH_GO_DOWN],
        [Maze::PATH_OPEN, Maze::PATH_OPEN, Maze::PATH_END]
      ]
      solver = MazeSolver.new(maze, 0, 0)
      expect(solver.solution).to eq(solution)
    end
  end

  context "#has_solution?" do
    it "returns true if there is a solution" do
      maze = [
        [Maze::PATH_OPEN, Maze::PATH_BLOCKED, Maze::PATH_OPEN,    Maze::PATH_OPEN,    Maze::PATH_OPEN,    Maze::PATH_OPEN],
        [Maze::PATH_OPEN, Maze::PATH_BLOCKED, Maze::PATH_OPEN,    Maze::PATH_BLOCKED, Maze::PATH_BLOCKED, Maze::PATH_OPEN],
        [Maze::PATH_OPEN, Maze::PATH_BLOCKED, Maze::PATH_OPEN,    Maze::PATH_OPEN,    Maze::PATH_BLOCKED, Maze::PATH_OPEN],
        [Maze::PATH_OPEN, Maze::PATH_BLOCKED, Maze::PATH_BLOCKED, Maze::PATH_OPEN,    Maze::PATH_BLOCKED, Maze::PATH_OPEN],
        [Maze::PATH_OPEN, Maze::PATH_OPEN,    Maze::PATH_OPEN,    Maze::PATH_OPEN,    Maze::PATH_BLOCKED, Maze::PATH_END]
      ]
      maze_solver = MazeSolver.new(maze, 0, 0)
      expect(maze_solver.has_solution?).to be true
    end

    it "returns false if there is no solution" do
      maze = [
        [Maze::PATH_OPEN, Maze::PATH_BLOCKED, Maze::PATH_BLOCKED],
        [Maze::PATH_BLOCKED, Maze::PATH_BLOCKED, Maze::PATH_BLOCKED],
        [Maze::PATH_BLOCKED, Maze::PATH_BLOCKED, Maze::PATH_BLOCKED],
        [Maze::PATH_BLOCKED, Maze::PATH_BLOCKED, Maze::PATH_END]
      ]
      maze_solver = MazeSolver.new(maze, 0, 0)
      expect(maze_solver.has_solution?).to be false
    end
  end

  context "#next_position_for" do
    let :maze_solver do
      maze_solver = MazeSolver.new([[]], 0, 0)
      allow(maze_solver).to receive(:solution).and_return([
        [Maze::PATH_GO_RIGHT, Maze::PATH_GO_DOWN],
        [Maze::PATH_GO_UP, Maze::PATH_GO_LEFT],
        [Maze::PATH_WRONG, Maze::PATH_WRONG]
      ])
      maze_solver
    end

    it "returns right cell if →" do
      expect(maze_solver.next_position_for(0, 0)).to eq([0, 1])
    end

    it "returns left cell if ←" do
      expect(maze_solver.next_position_for(1, 1)).to eq([1, 0])
    end

    it "returns upper cell if ↑" do
      expect(maze_solver.next_position_for(1, 0)).to eq([0, 0])
    end

    it "returns lower cell if ↓" do
      expect(maze_solver.next_position_for(0, 1)).to eq([1, 1])
    end

    it "returns same cell if there is no path" do
      expect(maze_solver.next_position_for(2, 0)).to eq([2, 0])
    end
  end
end