class Peck
  class Context
    attr_reader :specification

    def initialize(specification)
      @specification = specification
    end

    def describe(*args, &block)
      self.class.describe(*args, &block)
    end

    class << self
      FILENAME_WITHOUT_LINE_RE = /^(.+?):\d+/
      
      attr_reader :description, :block, :specs, :source_file
      attr_accessor :timeout

      def init(before, after, *description, &block)
        # Find the first file in the backtrace which is not this file
        source_file = caller.find { |line| line[0,__FILE__.size] != __FILE__ }
        if source_file
          source_file = source_file.match(FILENAME_WITHOUT_LINE_RE)[1]
          source_file = File.expand_path(source_file)
        else
          log("Unable to determine the file in which the context is defined.")
        end

        context = Class.new(self) do
          @before      = before.dup
          @after       = after.dup
          @source_file = source_file
          @description = description
          @block       = block
          @specs       = []
        end

        if @setup
          @setup.each { |b| b.call(context) }
        end

        Peck.contexts << context
        context.class_eval(&block)
        context
      end

      def label
        Peck.join_description(description)
      end

      def describe(*description, &block)
        if Peck.context_selector.match(Peck.join_description(*description))
          init(@before, @after, *description, &block)
        end
      end
      
      # Is only ran once for every context when it's initialized. Great place
      # to hook in test suite specific functionality.
      #
      #   Peck::Context.once { |context| context.before { @name = 'Mary' } }
      def once(&block)
        @setup ||= []
        @setup << block
      end
      
      def before(*args, &block)
        add_callback(@before, *args, &block)
      end
      alias setup before

      def after(*args, &block)
        add_callback(@after, *args, &block)
      end
      alias teardown after

      private

      def add_callback(chain, *args, &block)
        args.each do |method|
          chain << Proc.new { send(method) }
        end
        if block_given?
          chain << block
        end
      end
    end
  end

  PECK_PART_RE = /Peck/
  def self.join_description(description)
    description.map do |part|
      part = part.to_s
      part = nil if part =~ PECK_PART_RE
      part
    end.compact.join(' ')
  end
end

module Kernel
  private

  def describe(*description, &block)
    Peck::Context.init([], [], *description, &block)
  end
end