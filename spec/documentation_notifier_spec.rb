# encoding: utf-8

require File.expand_path('../preamble', __FILE__)
require 'peck/notifiers/documentation'
require 'stringio'

describe Peck::Notifiers::Documentation do
  before do
    @notifier = Peck::Notifiers::Documentation.new
  end

  it "prints the entire label for a spec" do
    spec = FakeSpec.new("Event should go on")

    capture_stdout do
      @notifier.started_specification(spec)
      @notifier.finished_specification(spec)
    end.should == "Event should go on \e[32m\342\234\223\e[0m (0 ms)\e[0m\n"
  end
end
