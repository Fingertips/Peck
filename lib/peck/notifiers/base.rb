class Peck
  class Notifiers
    class Base
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
    end
  end
end