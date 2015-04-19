describe DebugHelper do
  let :matrix do
    [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]
  end

  context ".matrix" do
    it "prints each row" do
      # 1 above + 3 rows + 1 bellow = 5
      expect(DebugHelper).to receive(:string).exactly(5).times
      DebugHelper.matrix(matrix)
    end

    it "doesn't print invalid data" do
      # "INVALID MATRIX!"
      expect(DebugHelper).to receive(:string).once
      DebugHelper.matrix("invalid")
    end
  end

  context ".string" do
    it "prints if in dev environment" do
      allow(Game).to receive(:config).and_return({environment: :development})
      expect(STDOUT).to receive(:puts).with("debug message")
      DebugHelper.string("debug message")
    end

    it "doesn't print if not in dev environment" do
      allow(Game).to receive(:config).and_return({environment: :production})
      expect(STDOUT).not_to receive(:puts).with("debug message")
      DebugHelper.string("debug message")
    end
  end
end