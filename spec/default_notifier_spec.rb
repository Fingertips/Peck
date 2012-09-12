# encoding: utf-8

require File.expand_path('../preamble', __FILE__)
require 'stringio'

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
    capture_stdout do
      @notifier.write_event(2, @event)
    end.should == "  2) Event should go on

  Is a good example of what might happen

\tspec/default_notifier_spec.rb:10

"
  end

  private

  def capture_stdout
    stdout = $stdout
    $stdout = written = StringIO.new('')
    begin
      yield
    ensure
      $stdout = stdout
    end
    written.rewind
    written.read
  end
end