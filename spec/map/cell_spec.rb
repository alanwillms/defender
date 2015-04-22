describe Cell do
  let :subject do
    Cell.new(instance_double("Map"), 0, 0)
  end

  it "does not accept negative rows or columns" do
    expect { Cell.new(instance_double("Map"), -1, -1) }.to raise_error(ArgumentError)
  end

  context "#point" do
    it "returns a Point" do
      expect(subject.point).to be_a(Point)
    end
  end
end