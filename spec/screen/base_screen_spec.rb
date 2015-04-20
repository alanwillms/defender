describe BaseScreen do
  it "#update" do
    expect(subject.update).to be nil
  end

  it "#draw" do
    expect(subject.draw).to be nil
  end

  it "#button_down" do
    expect(subject.button_down(nil)).to be nil
  end
end