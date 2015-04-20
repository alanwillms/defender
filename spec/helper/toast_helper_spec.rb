describe ToastHelper do
  let :font do
    font = instance_double('Gosu::Font')
    allow(font).to receive(:draw_rel).and_return(nil)
    font
  end

  before :each do
    allow(SpriteHelper).to receive(:font).and_return(font)
    allow(MapHelper).to receive(:tile_size).and_return(10)
    ToastHelper.class_variable_set(:@@messages, [])
  end

  context ".add_message" do
    it "creates a new ToastMessage" do
      expect(ToastMessage).to receive(:new).and_call_original
      ToastHelper.add_message("My message")
    end
  end

  context ".update" do
    it "removes expired messages" do
      allow(Gosu).to receive(:milliseconds).and_return(0)
      ToastHelper.add_message("My message")
      allow(Gosu).to receive(:milliseconds).and_return(ToastHelper::MESSAGE_DURATION + 1)
      expect_any_instance_of(Array).to receive(:delete)
      ToastHelper.update
    end
  end

  context ".draw" do
    context "has any message" do
      it "draws last message" do
        expect(font).to receive(:draw_rel).with("Last message", any_args)
        ToastHelper.add_message("First message")
        ToastHelper.add_message("Last message")
        ToastHelper.draw
      end
    end

    context "has no messages" do
      it "does nothing if there is no message" do
        expect(font).not_to receive(:draw_rel).with("Last message", any_args)
        ToastHelper.draw
      end
    end
  end
end