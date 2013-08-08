# encoding: utf-8

require 'peck/notifiers/default'

class Peck
  class Notifiers
    class Documentation < Peck::Notifiers::Default
      def initialize
        @spec_started_at = {}
      end

      def started_specification(spec)
        @spec_started_at[spec.object_id] = Time.now
      end

      def finished_specification(spec)
        start_time = @spec_started_at[spec.object_id]
        elapsed_time = ((Time.now - start_time) * 1000).round

        if spec.passed?
          puts "\e[32m✓\e[0m #{spec.label} (#{elapsed_time} ms)"
        else 
          puts "\e[31m✗#{spec.label} [FAILED]\e[0m"
        end
      end
    end
  end
end
