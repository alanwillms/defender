describe Maze do
  let :maze do
    map = instance_double('Map', rows: 3, columns: 3)
    monster_spawner = instance_double('MonsterSpawner', row: 0, column: 0)
    defending_city = instance_double('DefendingCity', row: 2, column: 2)
    allow(map).to receive(:monster_spawners).and_return([monster_spawner])
    allow(map).to receive(:defending_cities).and_return([defending_city])
    Maze.new(map)
  end

  context "#cell_blocked?" do
    it "returns true if the cell is blocked" do
      maze.matrix[2][2] = Maze::PATH_BLOCKED
      expect(maze.cell_blocked?(2, 2)).to be true
    end

    it "returns false if the cell is not blocked" do
      maze.matrix[2][2] = Maze::PATH_OPEN
      expect(maze.cell_blocked?(2, 2)).to be false
    end
  end

  context "#block" do
    it "mark the cell as blocked" do
      maze.block(2, 2)
      expect(maze.matrix[2][2]).to eq(Maze::PATH_BLOCKED)
    end
  end

  context "#block_all_paths?" do
    # S # .
    # . . .
    # . . G
    it "returns true if blocking the cell blocks all paths" do
      maze.block(0, 1)
      expect(maze.block_all_paths?(1, 0)).to be true
    end

    it "returns false if blocking the cell does not block all paths" do
      maze.block(2, 1)
      expect(maze.block_all_paths?(1, 0)).to be false
    end
  end

  context "#create_solver" do
    it "returns an instance of MazeSolver" do
      expect(maze.create_solver(maze.matrix, 0, 0)).to be_a(MazeSolver)
    end
  end
end