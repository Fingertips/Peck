class Peck
  class << self
    attr_accessor :counter
  end

  class Counter
    def self.instance
      @instance ||= new
    end

    attr_accessor :ran, :passed, :failed, :pending, :errors

    def initialize
      @ran = @passed = @failed = @pending = @errors = 0
      @started_at = @stopped_at = Time.now
      @events = []
      $stdout.sync = true
    end

    def started
      @started_at = Time.now
    end

    def finished
      @finished_at = Time.now
    end

    def finished_spec(spec)
      @ran += 1
      if spec.error?
        @errors += 1
      elsif spec.passed?
        @passed += 1
      elsif specification.failure?
        @failed += 1
      end
    end
  end

  self.counter = Counter.instance

  if respond_to?(:delegates)
    self.delegates << self.counter
  end
end