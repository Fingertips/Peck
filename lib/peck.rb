class Peck
  VERSION = "0.1.0"
  
  class << self
    # Returns all the defined contexts.
    attr_reader :contexts

    # Used to select which contexts should be run. The match method will be
    # called on these with the label of the context as argument. You can use
    # a regular expression or a custom class to match what needs to be run.
    #
    #   module ContextMatcher
    #     def self.match(label)
    #       label =~ /^Birds/
    #     end
    #   end
    #   Peck.context_selector = ContextMatcher
    attr_accessor :context_selector

    # Used to select which specs should be run. See Peck.select_context
    # for more information.
    attr_accessor :spec_selector

    # Sets the level of concurrency.
    attr_accessor :concurrency
  end

  # A no-op unless you require 'peck/debug'
  def self.log(message)
  end

  # Returns true if the suite should run concurrent.
  def self.concurrent?
    concurrency && concurrency > 1
  end

  def self.reset!
    @contexts = []
  end

  @context_selector = //
  @spec_selector = //

  reset!

  def self.all_specs
    contexts.inject([]) do |all, context|
      all.concat(context.specs)
    end
  end

  def self.all_events
    contexts.inject([]) do |all, context|
      context.specs.inject(all) do |events, spec|
        events.concat(spec.events)
      end
    end
  end

  def self.run
    delegates.started
    concurrent? ? run_concurrent : run_serial
    delegates.finished
  end

  def self.run_at_exit
    at_exit do
      run
    end
  end

  def self.run_serial
    Peck.log("Running specs in serial")
    Thread.current['peck-semaphore'] = Mutex.new
    contexts.each do |context|
      context.specs.each do |specification|
        delegates.started_specification(specification)
        specification.run
        delegates.finished_specification(specification)
      end
    end
  rescue Exception => e
    log("An error bubbled up from the context, this should never happen and is possibly a bug.")
    raise e
  end

  def self.run_concurrent
    Peck.log("Running specs concurrently")
    current_spec = -1
    specs = all_specs
    threaded do |nr|
      Thread.current['peck-semaphore'] = Mutex.new
      loop do
        spec_index = Thread.exclusive { current_spec += 1 }
        if specification = specs[spec_index]
          delegates.started_specification(specification)
          specification.run
          delegates.finished_specification(specification)
        else
          break
        end
      end
    end

    delegates.finished
  end

  def self.threaded
    threads = []
    Peck.concurrency.times do |nr|
      threads[nr] = Thread.new do
        yield nr
      end
    end

    threads.compact.each do |thread|
      begin
        thread.join
      rescue Interrupt
      end
    end
  end
end
