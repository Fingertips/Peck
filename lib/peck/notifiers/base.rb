class Peck
  class Notifiers
    class Base
      module BacktraceCleaning
        # When a file starts with this path, it's in the Peck library
        PECK_PATH = File.expand_path('../../../../', __FILE__)

        # Matches: `block (2 levels) in <top (required)>'
        ANONYMOUS_BLOCK_RE = /`block/

        def clean_backtrace(backtrace)
          stripped = []
          backtrace.each do |line|
            if line.start_with?(PECK_PATH) || line.start_with?("<")
            elsif line =~ ANONYMOUS_BLOCK_RE
              stripped << line.split(':')[0,2].join(':')
            else
              stripped << line
            end
          end
          stripped.empty? ? backtrace : stripped
        end
      end

      def self.use
        @instance ||= begin
          notifier = new
          notifier.install_at_exit
          Peck.delegates << notifier
          notifier
        end
      end

      protected

      def pluralize(count, stem)
        count == 1 ? stem : "#{stem}s"
      end

      include BacktraceCleaning
    end
  end
end