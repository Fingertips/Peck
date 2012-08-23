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

      def write_exeception(number, exception)
        puts "  #{number}) #{exception.message}"
        backtrace = clean_backtrace(exception.backtrace)
        puts "\t#{backtrace.join("\n\t")}\n\n"
      end
      
      def write_event(number, event)
        case event
        when Exception
          write_exeception(number, event)
        end
      end

      def write_events
        Peck.all_events.each_with_index do |event, index|
          number = index + 1
          write_event(number, event)
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
        write_stats
      end

      def install_at_exit
        at_exit { write }
      end
    end
  end
end