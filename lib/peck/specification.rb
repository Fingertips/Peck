class Peck
  class Context
    def self.it(description, &block)
      return unless Peck.spec_selector.match(label)
      specification = Specification.new(self, @before, @after, description, &block)
      @specs << specification
      specification
    end

    def self.pending(description)
      return unless Peck.spec_selector.match(label)
      delegates.received_pending(description)
    end
  end

  class Specification
    attr_reader :description, :context
    attr_accessor :expectations, :errors

    def initialize(context, before, after, description, &block)
      @context      = context.new(self)
      @before       = before.dup
      @after        = after.dup
      @description  = description
      @block        = block

      @expectations = []
      @events       = []

      @finished = false
    end

    def label
      "#{@context.class.label} #{@description}"
    end

    def synchronized(&block)
      if semaphore = Thread.current['peck-semaphore']
        semaphore.synchronize(&block)
      else
        block.call
      end
    end

    def run
      if @block
        @before.each { |cb| @context.instance_eval(&cb) }
        synchronized do
          Thread.current['peck-spec'] = self
          @context.instance_eval(&@block)
          Thread.current['peck-spec'] = nil
        end
        Peck.delegates.received_missing(self) if empty?
        @after.each { |cb| @context.instance_eval(&cb) }
      else
        Peck.delegates.received_missing(self)
      end
    rescue Object => e
      Peck.delegates.received_exception(self, e)
      @events << e
    ensure
      @finished = true
    end

    def empty?
      @expectations.empty?
    end

    def failed?
      !@events.empty?
    end

    def passed?
      !failed? && !@expectations.empty?
    end
  end
end