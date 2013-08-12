# encoding: utf-8

require 'peck/notifiers/default'

class Peck
  class Notifiers
    class Documentation < Peck::Notifiers::Default
      class << self
        # The cutoff point beyond which a test is reported as being slow.
        # Expressed in milliseconds. Default is 500ms.
        attr_accessor :runtime_report_cutoff
      end
      self.runtime_report_cutoff = 500

      # Keeps all the labels, start, and end times for the specs
      attr_accessor :details

      # A FIFO queue of all the started specs being first on the queue means
      # the spec has been reported as started. Being on the queue means the
      # spec still needs to be reported as being finished.
      attr_accessor :running

      # Mutex to synchronize the access of the global data structures
      attr_accessor :semaphore

      def initialize
        self.details = {}
        self.running = []
        self.semaphore = Mutex.new
      end

      def started_specification(spec)
        self.semaphore.synchronize do
          spec_id = spec.object_id
          self.running.push(spec_id)
          self.details[spec_id] ||= {}
          self.details[spec_id][:started_at] = Time.now
          self.details[spec_id][:label] = spec.label
          write_documentation
        end
      end

      def finished_specification(spec)
        self.semaphore.synchronize do
          spec_id = spec.object_id
          self.details[spec_id][:finished_at] = Time.now
          self.details[spec_id][:passed] = spec.passed?
          write_documentation
        end
      end

      protected

      def write_spec_started(details)
        $stdout.write(details[:label])
      end

      def write_spec_finished(details)
        elapsed_time = ((details[:finished_at] - details[:started_at]) * 1000).round
        color = self.class.runtime_report_cutoff < elapsed_time ? "\e[35m" : ''
        if details[:passed]
          $stdout.puts " \e[32m✓\e[0m #{color}(#{elapsed_time} ms)\e[0m"
        else 
          $stdout.puts " \e[31m✗ [FAILED]\e[0m"
        end
      end

      def write_documentation
        spec_id = self.running.first
        details = self.details[spec_id]

        unless details[:start_reported]
          write_spec_started(details)
          details[:start_reported] = true
        end

        if details[:finished_at]
          write_spec_finished(details)
          self.details.delete(spec_id)
          self.running.shift
        end
      end
    end
  end
end
