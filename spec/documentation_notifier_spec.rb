# encoding: utf-8

require File.expand_path('../preamble', __FILE__)
require 'stringio'

describe Peck::Notifiers::Documentation do
  before do
    @notifier = Peck::Notifiers::Documentation.new
  end

  it "formats test failures into a readable format" do
    exception = nil
    begin
      raise ArgumentError, "Is a good example of what might happen"
    rescue => e
      exception = e
    end

    spec = FakeSpec.new("Event should go on")
    event = Peck::Event.new(exception, spec)

    capture_stdout do
      @notifier.write_event(2, event)
    end.should == "  2) Event should go on

  Is a good example of what might happen

\tspec/documentation_notifier_spec.rb:14

"
  end

  it "formats test failures without a message" do
    exception = nil
    begin
      fail
    rescue => e
      exception = e
    end

    spec = FakeSpec.new("Event should go on")
    event = Peck::Event.new(exception, spec)

    capture_stdout do
      @notifier.write_event(2, event)
    end.should == "  2) Event should go on

\tspec/documentation_notifier_spec.rb:36

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
