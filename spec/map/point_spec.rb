describe Point do
  it "does not accept negative coordinates" do
    expect { Point.new(-1, -1, -1) }.to raise_error(ArgumentError)
  end
end