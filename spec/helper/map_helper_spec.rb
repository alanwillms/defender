describe MapHelper do
  context ".screen_padding" do
    it "returns Game.config value" do
      expect(MapHelper.screen_padding).to eq(Game.config[:screen_padding])
    end
  end

  context ".tile_size" do
    it "returns Game.config value" do
      expect(MapHelper.tile_size).to eq(Game.config[:tile_size])
    end
  end

  context ".get_x_for_column" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_x_for_column(5)).to eq(MapHelper.screen_padding + (5 * MapHelper.tile_size))
    end
  end

  context ".get_y_for_row" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_y_for_row(5)).to eq(MapHelper.screen_padding + (5 * MapHelper.tile_size))
    end
  end

  context ".get_column_for_x" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_column_for_x(MapHelper.screen_padding + (5 * MapHelper.tile_size))).to eq(5)
    end
  end

  context ".get_row_for_y" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_row_for_y(MapHelper.screen_padding + (5 * MapHelper.tile_size))).to eq(5)
    end
  end

  context ".fix_z_for_row" do
    it "increase z by number of rows" do
      expect(MapHelper.fix_z_for_row(0, 123)).to eq(123)
    end
  end

  context ".clone_matrix" do
    it "duplicates the matrix" do
      matrix = [[1, 2, 3], [4, 5, 6], [:value, 0, "Other"]]
      expect(MapHelper.clone_matrix(matrix)).to eq(matrix)
    end
  end

  context ".create_matrix" do
    it "creates matrix with informed value" do
      matrix = [[:value, :value, :value], [:value, :value, :value]]
      expect(MapHelper.create_matrix(2, 3, :value)).to eq(matrix)
    end
  end

  context ".tiles_distance" do
    it "calculates distance between two points in tiles" do
      p1 = [0, 0]
      p2 = [0, MapHelper.tile_size]
      expect(MapHelper.tiles_distance(p1, p2)).to eq(1)
    end
  end
end