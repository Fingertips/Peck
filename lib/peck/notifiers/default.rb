require 'peck/notifiers/base'

class Peck
  class Notifiers
    class Default < Peck::Notifiers::Base
      def initialize
        @started_at = @finished_at = Time.now
      end

      def started
        @started_at = Time.now
      end

      def finished
        @finished_at = Time.now
      end

      def finished_specification(spec)
        if spec.passed?
          $stdout.write('.')
        elsif spec.failed?
          $stdout.write('f')
        end
      end

      def write_exeception(exception)
        puts exception.message
        puts exception.backtrace.join("\n\t")
      end
      
      def write_event(event)
        case event
        when Exception
          write_exeception(event)
        end
      end

      def write_events
        Peck.all_events.each do |event|
          write_event(event)
        end
      end

      def runtime_in_seconds
        runtime = @finished_at - @started_at
        (runtime * 100).round / 100.0
      end

      def write_stats
        puts "#{Peck.counter.ran} #{pluralize(Peck.counter.ran, 'spec')}, #{Peck.counter.failed} #{pluralize(Peck.counter.failed, 'failure')}, finished in #{runtime_in_seconds} seconds."
      end

      def write
        puts if Peck.counter.ran > 0
        write_events
        puts unless Peck.counter.events.empty?
        write_stats
      end

      def install_at_exit
        at_exit { write }
      end
    end
  end
end