describe Cell do
  let :map do
    map = Map.new(Game.current_window.current_screen, 3, 3)
    map.build MonsterSpawner.new(Cell.new(map, 0, 0))
    map.build DefendingCity.new(Cell.new(map, 2, 2))
    map
  end

  let :subject do
    Cell.new(map, 0, 0)
  end

  it "does not accept negative rows or columns" do
    expect { Cell.new(instance_double("Map"), -1, -1) }.to raise_error(ArgumentError)
  end

  context "#point" do
    it "returns a Point" do
      expect(subject.point).to be_a(Point)
    end
  end

  context "#blocked?" do
    it "returns true if the cell is blocked" do
      subject.map.maze.matrix[0][0] = Maze::PATH_BLOCKED
      expect(subject.blocked?).to be true
    end

    it "returns false if the cell is not blocked" do
      subject.map.maze.matrix[0][0] = Maze::PATH_OPEN
      expect(subject.blocked?).to be false
    end
  end

  context "#block" do
    it "mark the cell as blocked" do
      subject.block
      expect(subject.map.maze.matrix[0][0]).to eq(Maze::PATH_BLOCKED)
    end
  end

  context "#would_block_any_path?" do
    # S # .
    # . . .
    # . . G
    context "can exit through 1,0" do
      it "returns true on blocking 1,0" do
        Cell.new(map, 0, 1).block
        cell = Cell.new(map, 1, 0)
        expect(cell.would_block_any_path?).to be true
      end
    end

    # S . .
    # . . .
    # . # G
    context "can exit through 0,1 or 1,0" do
      it "returns false on blocking 1,0" do
        Cell.new(map, 2, 1).block
        cell = Cell.new(map, 1, 0)
        expect(cell.would_block_any_path?).to be false
      end
    end
  end
end