# encoding: utf-8

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

  class Event
    attr_accessor :exception, :spec

    def initialize(exception, spec)
      @exception = exception
      @spec = spec
    end
  end

  class Specification
    attr_reader :description, :context
    attr_reader :expectations, :events

    def initialize(context, before, after, description, &block)
      @context      = context.new(self)
      @before       = before.dup
      @after        = after.dup
      @description  = description
      @block        = block

      @expectations = []
      @events       = []
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

    def run delegates
      delegates.started_specification(self)
      if @block
        @before.each { |cb| @context.instance_eval(&cb) }
        begin
          synchronized do
            Thread.current['peck-spec'] = self
            @context.instance_eval(&@block)
            Thread.current['peck-spec'] = nil
          end
          Peck.delegates.received_missing(self) if empty?
        ensure
          @after.each { |cb| @context.instance_eval(&cb) }
        end
      else
        delegates.received_missing(self)
      end
    rescue Object => e
      Peck.delegates.received_exception(self, e)
      @events << Event.new(e, self)
    ensure
      delegates.finished_specification(self)
    end

    def empty?
      @expectations.empty?
    end

    def failed?
      !@events.empty?
    end

    def passed?
      !failed? && !empty?
    end
  end
end