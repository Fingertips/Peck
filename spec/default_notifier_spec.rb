require File.expand_path('../preamble', __FILE__)

class FakeSpec < Struct.new(:label)
end

describe Peck::Notifiers::Default do
  before do
    begin
      raise ArgumentError, "Is a good example of what might happen"
    rescue => e
      @e = e
    end
    @notifier = Peck::Notifiers::Default.new
    @spec = FakeSpec.new("Event should go on")
    @event = Peck::Event.new(@e, @spec)
  end

  it "formats test failures into a readable format" do
    @notifier.write_event(2, @event)
  end

  it "formats exceptions into a readable format" do
  end
end