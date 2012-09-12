# encoding: utf-8

class Peck
  class << self
    attr_accessor :counter
  end

  class Counter
    def self.instance
      @instance ||= new
    end

    attr_accessor :ran, :passed, :failed, :pending, :missing, :events

    def initialize
      @ran = @passed = @failed = 0
      @pending = []
      @missing = []
      @events  = []
      $stdout.sync = true
    end

    def finished_specification(spec)
      @ran += 1
      if spec.passed?
        @passed += 1
      elsif spec.failed?
        @failed += 1
      end
    end

    def received_pending(label)
      @pending << label
    end

    def received_missing(spec)
      @missing << spec
    end

    def received_exception(spec, exception)
      @events << exception
    end
  end

  self.counter = Counter.instance

  if respond_to?(:delegates)
    self.delegates << self.counter
  end
end