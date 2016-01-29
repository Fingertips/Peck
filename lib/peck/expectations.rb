# encoding: utf-8

require 'peck/error'

class Peck
  class Should
    class Proxy
      attr_accessor :negated
      attr_reader :context, :block

      def initialize(context, &block)
        @context = context
        @block = block
        @negated = false
      end
    end

    # A Specification is a proxy object which eventually generates
    # a specification on the context. This is used by the should
    # method in the context class.
    class Specification < Proxy
      def not
        @negated = !@negated
        self
      end
    end

    # Kills ==, ===, =~, eql?, equal?, frozen?, instance_of?, is_a?,
    # kind_of?, nil?, respond_to?, tainted?
    KILL_METHODS_RE = /\?|^\W+$/
    instance_methods.each do |name|
      undef_method(name) if name =~ KILL_METHODS_RE
    end

    def initialize(this)
      @this = this
      @negated = false
      Thread.current['peck-spec'].expectations << self
    end

    def not
      @negated = !@negated
      self
    end

    def be(*args, &block)
      if args.empty?
        self
      else
        block = args.shift unless block_given?
        satisfy(*args, &block)
      end
    end

    def satisfy(*args, &block)
      if args.size == 1 && String === args.first
        description = args.shift
      else
        description = ""
      end

      result = yield(@this, *args)
      unless @negated ^ result
        Kernel.raise Peck::Error.new(:failed, description)
      end
      result
    end

    def change(*expected)
      block_binding = @this.send(:binding)

      before = expected.each_slice(2).map do |expression, _|
        eval(expression, block_binding)
      end

      block_result = @this.call

      expected.each_slice(2).with_index do |(expression, change), index|
        after = eval(expression, block_binding)
        actual = after - before[index]

        if @negated
          description = "#{expression} changed"
          description << " by expected #{change}" if change
          description << ", actual change: #{actual}"
        else
          description = "#{expression} didn't change"
          description << " by expected #{change}" if change
          description << ", actual change: #{actual}"
        end

        satisfy(description) do |x|
          if change
            after == (before[index] + change)
          else
            before[index] != after
          end
        end
      end

      block_result
    end

    def raise(exception_class=nil)
      exception = nil
      begin
        @this.call
      rescue Exception => e
        exception = e
      end

      description = if exception_class
        if @negated
          "expected `#{exception_class}' to not be raised"
        else
          "expected `#{exception_class}' to be raised, but got a `#{exception.class}'"
        end
      else
        if @negated
          "expected nothing to be raised, but got `#{exception.inspect}'"
        else
          "expected an exception, but nothing was raised"
        end
      end

      satisfy(description) do
        if exception_class
          exception.kind_of?(exception_class)
        else
          !exception.nil?
        end
      end
    end

    PREDICATE_METHOD_RE = /\w[^?]\z/
    def method_missing(name, *args, &block)
      name = "#{name}?" if name.to_s =~ PREDICATE_METHOD_RE

      desc = @negated ? "not " : ""
      desc << @this.inspect << "." << name.to_s
      desc << "(" << args.map{|x|x.inspect}.join(", ") << ") failed"

      satisfy(desc) { |x| x.__send__(name, *args, &block) }
    end
  end
end

class Object
  def should(*args, &block)
    if self.kind_of?(Class) && (self < Peck::Context)
      Peck::Should::Specification.new(self)
    else
      Peck::Should.new(self).be(*args, &block)
    end
  end
end
